declare @TrxDate datetime
set @TrxDate='2019-10-09' 

--DUES-OUT
select
	X.req_no,
	item_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',X.status,'EN')   status,
	stock_code,
	wh_id,
	kms.Getlookupdesc('SU_IST',item_status ,'EN') item_status,
	rcv_wh_id,
	src_wh_id
	--qty_req,
	--qty_allocated,
	--qty_issued,
	--qty_outstanding,
	--qty_purchased,
	--qty_received,
	--convert_fact,
	--Dues_out_manual qty,
	--formula,
	--qty_wh_req
from
	(
	select
		Stock_Code,
		item_no              item_no,
		rcv_WhoUse_Id        wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		qty_issued                              qty_allocated,
		qty_received							qty_issued,
		qty_outstanding,
		0                    qty_purchased,
		0                    qty_received,
		null                 convert_fact,
		(qty_wh_req)            Dues_out_manual,
		'Dues out = SOH_Update_qty' formula,
			qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
	    left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'Rx'
		and status = 'SBMT' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and inv_no is null --not added to a invoice
		and head.rcv_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		rcv_WhoUse_Id                           wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		qty_issued                              qty_allocated,
		qty_received							qty_issued,
		qty_outstanding,
		0                                       qty_purchased,
		0                                       qty_received,
		null                                    convert_fact,
		(qty_issued - qty_received)             Dues_out_manual,
		'Dues out = qty_allocated - qty_issued' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'Rx'
		and status in ('ALLC','PRTD')
		and item.item_status = 'ISSD' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.rcv_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		rcv_WhoUse_Id              wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		qty_issued                qty_allocated,
		qty_received			  qty_issued,
		qty_outstanding,
		0                          qty_purchased,
		0                          qty_received,
		null                       convert_fact,
		(qty_wh_req)               Dues_out_manual,
		'Dues out = SOH_Update_qty' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'Rx'
		and status = 'ALLC'
		and item.item_status = 'CMPL' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.rcv_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		rcv_WhoUse_Id        wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		0                    qty_allocated,
		qty_issued,
		qty_outstanding,
		0                    qty_purchased,
		0                    qty_received,
		null                 convert_fact,
		(item.qty_req)            Dues_out_manual,
		'Dues out = qty_req' formula,
		item.qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'STRQ'
		and head.tran_type <> 'CRRT'
		and status = 'SBMT' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.rcv_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		src_WhoUse_Id        wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		0                    qty_allocated,
		qty_issued,
		qty_outstanding,
		0                    qty_purchased,
		0                    qty_received,
		null                 convert_fact,
		(item.qty_req)            Dues_out_manual,
		'Dues out = qty_req' formula,
		item.qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'STTR'
		and status = 'SBMR' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.src_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		src_WhoUse_Id        wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		0                    qty_allocated,
		qty_issued,
		qty_outstanding,
		0                    qty_purchased,
		0                    qty_received,
		null                 convert_fact,
		(item.qty_req)            Dues_out_manual,
		'Dues out = qty_req' formula,
		item.qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'STTR'
		and status in ('APRR','SBMT')
		and item.item_status not in ('CCLR','NARR') 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.src_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL 
	select
		Stock_Code,
		item_no,
		src_WhoUse_Id        wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		item.qty_req,
		0                    qty_allocated,
		qty_issued,
		qty_outstanding,
		0                    qty_purchased,
		0                    qty_received,
		null                 convert_fact,
		(item.qty_req)            Dues_out_manual,
		'Dues out = qty_req' formula,
		item.qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	from
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item 
		left join kms.KMS_ADM_INVC_ITEM invc_item on item.req_no = invc_item.ref_id
	where
		head.req_no = item.req_no
		and head.req_type = 'STTR'
		and status = 'APRV'
		and item.item_status in ('APPR','CMPL','CNCL')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND (item.comp_medication IS NULL OR comp_medication < 1)
		and inv_no is null
		and head.src_WhoUse_Id IN (SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE')
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	select
		comp.Stock_Code,
		comp.item_no,
		'PRWH'					src_WhoUse_Id,
		comp.prod_order_no		req_No,
		'PP'					req_Type,
		''						Status,
		''						item_status,
		comp.req_qty			qty_req,
		comp.act_qty     		qty_allocated,
		0						qty_issued,
		0						qty_outstanding,
		0           			qty_purchased,
		0           			qty_received,
		null        			convert_fact,
		(comp.req_qty)   		Dues_out_manual,
		'Dues out = qty_req'	formula, 
		0						qty_wh_req,
		null,
		null
	from
		kms.kms_supl_ppo_item item,
		kms.kms_supl_ppo_item_comp comp
	where
		item.prod_order_no = comp.prod_order_no
		and item.item_no = comp.item_no
		and item.status = 'NEW'
		and allocated = '1'
) X 
where
	dues_out_manual <> 0