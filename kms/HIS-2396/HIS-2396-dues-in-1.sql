select tbl_wh_inv.stock_code, tbl_wh_inv.whouse_id, kms.getlookupdesc('SU_WID',tbl_wh_inv.whouse_id, 'EN') whouse_name, tbl_wh_inv.dues_in, case when tbl_dues_in.Dues_in_manual is null then 0 else tbl_dues_in.Dues_in_manual end as Dues_in_manual
From kms.KMS_SUPL_WARH_INVN tbl_wh_inv
left join 
	(select
	tbl_dues_in.stock_code, tbl_dues_in.wh_id, sum(tbl_dues_in.Dues_in_manual) as Dues_in_manual
	from
		(SELECT
			tbl_dues_in.req_no,
			tbl_dues_in.req_Type      req_type_code,
			CASE 
				WHEN req_Type = 'PORD' THEN 'Purchase Order' 
				ELSE kms.Getlookupdesc('SU_RQT',req_Type,'EN') 
			END req_Type, 
			CASE 
				WHEN req_Type = 'PORD' THEN kms.Getlookupdesc('SU_POST',tbl_dues_in.Status,'EN') 
				WHEN req_Type = 'PP' THEN kms.Getlookupdesc('SU_PPO',tbl_dues_in.Status,'EN')
				ELSE kms.Getlookupdesc('SU_TST',tbl_dues_in.Status,'EN') 
			END status,
			CASE 
				WHEN req_Type = 'PORD' THEN kms.Getlookupdesc('SU_POIST',item_status ,'EN')
				WHEN req_Type = 'PP' THEN kms.Getlookupdesc('SU_PPO',item_status,'EN') 
				ELSE kms.Getlookupdesc('SU_IST',item_status ,'EN') 
			END item_status, 
			stock_code,wh_id,
			--item_status,qty_req,
			qty_allocated,qty_issued,
			qty_outstanding,qty_purchased,
			qty_received,convert_fact,
			Dues_In_manual qty,
			formula,
			qty_wh_req,
			Dues_In_manual
		FROM
			(
			SELECT
				Stock_Code,
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
				qty_wh_req
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
				qty_wh_req 
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
				qty_wh_req
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
				qty_wh_req 
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
				0 															   qty_wh_req 
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
				0						qty_wh_req 
			FROM
				kms.kms_supl_ppo_item item
			WHERE
				status = 'INPR'
		) tbl_dues_in ) tbl_dues_in
		group by tbl_dues_in.stock_code, tbl_dues_in.wh_id) tbl_dues_in
on tbl_dues_in.stock_code=tbl_wh_inv.stock_code and tbl_dues_in.wh_id=tbl_wh_inv.whouse_id
where 
tbl_wh_inv.dues_in <> case when tbl_dues_in.Dues_in_manual is null then 0 else tbl_dues_in.Dues_in_manual end
order by tbl_wh_inv.whouse_id, tbl_wh_inv.stock_code