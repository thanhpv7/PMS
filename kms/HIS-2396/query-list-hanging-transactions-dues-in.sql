--- Due in ---
SELECT
	x.req_no,
	item_no,
	x.req_Type      req_type_code,
	CASE 
		WHEN req_Type = 'PORD' THEN 'Purchase Order' 
		ELSE kms.Getlookupdesc('SU_RQT',req_Type,'EN') 
	END req_Type, 
	CASE 
		WHEN req_Type = 'PORD' THEN kms.Getlookupdesc('SU_POST',x.Status,'EN') 
		WHEN req_Type = 'PP' THEN kms.Getlookupdesc('SU_PPO',x.Status,'EN')
		ELSE kms.Getlookupdesc('SU_TST',x.Status,'EN') 
	END status,
	stock_code,
	wh_id,
	CASE 
		WHEN req_Type = 'PORD' THEN kms.Getlookupdesc('SU_POIST',item_status ,'EN')
		WHEN req_Type = 'PP' THEN kms.Getlookupdesc('SU_PPO',item_status,'EN') 
		ELSE kms.Getlookupdesc('SU_IST',item_status ,'EN') 
	END item_status,
	--item_status,
	rcv_wh_id,
	src_wh_id
	--qty_req,
	--qty_allocated,qty_issued,
	--qty_outstanding,qty_purchased,
	--qty_received,convert_fact,
	--Dues_In_manual qty,
	--formula,
	--qty_wh_req 
FROM
	(
	SELECT
		Stock_Code,
		item_no              item_no,
		rcv_WhoUse_Id       wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		qty_req,
		0                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                   qty_purchased,
		0                   qty_received,
		null                convert_fact,
		(qty_req)           Dues_In_manual,
		'Dues in = qty_req' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.KMS_SUPL_MTRL_TRANS_HEAD Head,
		kms.KMS_SUPL_MTRL_TRANS_ITEM Item 
	WHERE
		Head.req_No = Item.req_No
		AND Head.req_Type = 'STTR'
		AND Status = 'SBMR' 
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
	UNION ALL 
	SELECT
		Stock_Code,
		item_no,
		rcv_WhoUse_Id       wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		qty_req,
		0                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                   qty_purchased,
		0                   qty_received,
		null                convert_fact,
		(qty_req)           Dues_In_manual,
		'Dues in = qty_req' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	FROM
		kms.KMS_SUPL_MTRL_TRANS_HEAD Head,
		kms.KMS_SUPL_MTRL_TRANS_ITEM Item 
	WHERE
		Head.req_No = Item.req_No
		AND Head.req_Type = 'STTR'
		AND Status IN ('APRR','SBMT')
		AND Item.Item_Status NOT IN ('CCLR','NARR')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
	UNION ALL 
	SELECT
		Stock_Code,
		item_no,
		rcv_WhoUse_Id       wh_id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		qty_req,
		0                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                   qty_purchased,
		0                   qty_received,
		null                convert_fact,
		(qty_req)           Dues_In_manual,
		'Dues in = qty_req' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.KMS_SUPL_MTRL_TRANS_HEAD Head, 
		kms.KMS_SUPL_MTRL_TRANS_ITEM Item 
	WHERE
		Head.req_No = Item.req_No
		AND Head.req_Type = 'STTR'
		AND Status = 'APRV'
		AND Item.Item_Status IN ('APPR','CMPL','CNCL')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
	UNION ALL 
	SELECT
		Stock_Code,
		item_no,
		rcv_WhoUse_Id       wh_Id,
		Head.req_No,
		req_Type,
		Status,
		item.item_status,
		qty_req,
		0                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                   qty_purchased,
		0                   qty_received,
		null                convert_fact,
		(qty_req)           Dues_In_manual,
		'Dues in = qty_req' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id 
	FROM
		kms.KMS_SUPL_MTRL_TRANS_HEAD Head,
		kms.KMS_SUPL_MTRL_TRANS_ITEM Item 
	WHERE
		Head.req_No = Item.req_No
		AND Head.req_Type = 'STRQ'
		AND Head.tran_type = 'CRRT'
		AND Status = 'SBMT'
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
	UNION ALL 
	SELECT
		Item.Stock_Code,
		Item.po_item_no,
		Item.WhoUse_Id                                                 wh_Id,
		Head.po_No                                                     req_No,
		'PORD'                                                         req_Type,
		po_Status,
		item.status                                                    item_status,
		0                                                              qty_req,
		0                                                              qty_allocated,
		0                                                              qty_issued,
		0                                                              qty_outstanding,
		qty_purchased,
		qty_received,
		convert_fact,
		((Item.qty_Purchased - Item.qty_Received) * Item.Convert_Fact) Dues_In_manual,
		'qty_Purchased - qty_Received * Convert_Fact'                  formula,
		0 															   qty_wh_req,
		null,
		null 
	FROM
		kms.KMS_SUPL_PO_HEAD Head,
		kms.KMS_SUPL_PO_ITEM Item 
	WHERE
		po_Status = 'PRNT'
		AND Item.Status = 'AUTH'
		AND Head.po_No = Item.po_No
		AND Head.po_sys = Item.po_sys
		AND Item.qty_Purchased > Item.qty_Received
	UNION ALL 
	SELECT
		Stock_Code,
		item_no,
		rcv_whouse					wh_Id,
		prod_order_no				req_No,
		'PP'						req_Type,
		status,
		status						item_status,
		0							qty_req,
		0							qty_allocated,
		0							qty_issued,
		0							qty_outstanding,
		plan_qty					qty_purchased,
		actual_qty					qty_received,
		cnv_fact					convert_fact,
		(actual_qty * cnv_fact)		Dues_In_manual,
		'actual_qty * cnv_fact'	formula,
		0						qty_wh_req,
		null,
		null 
	FROM
		kms.kms_supl_ppo_item item
	WHERE
		status = 'INPR'
	) x 
WHERE
	Dues_In_manual <> 0