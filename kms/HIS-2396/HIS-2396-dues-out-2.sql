select tbl_wh_inv.stock_code, tbl_wh_inv.whouse_id, kms.getlookupdesc('SU_WID',tbl_wh_inv.whouse_id, 'EN') whouse_name, tbl_wh_inv.dues_out, case when tbl_dues_out.Dues_out_manual is null then 0 else tbl_dues_out.Dues_out_manual end as Dues_out_manual
From kms.KMS_SUPL_WARH_INVN tbl_wh_inv
left join 
	(select
	tbl_dues_out.stock_code, tbl_dues_out.wh_id, sum(tbl_dues_out.Dues_out_manual) as Dues_out_manual
	from
		(
			select
				Stock_Code,
				rcv_WhoUse_Id        wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				qty_issued                              qty_allocated,
				qty_received							qty_issued,
				qty_outstanding,
				0                    qty_purchased,
				0                    qty_received,
				null                 convert_fact,
				(qty_wh_req)            Dues_out_manual,
				'Dues out = SOH_Update_qty' formula,
				 qty_wh_req
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'Rx'
				and status = 'SBMT' 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				rcv_WhoUse_Id                           wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				qty_issued                              qty_allocated,
				qty_received							qty_issued,
				qty_outstanding,
				0                                       qty_purchased,
				0                                       qty_received,
				null                                    convert_fact,
				(qty_issued - qty_received)             Dues_out_manual,
				'Dues out = qty_allocated - qty_issued' formula,
				qty_wh_req 
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'Rx'
				and status in ('ALLC','PRTD')
				and item_status = 'ISSD' 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				rcv_WhoUse_Id              wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				qty_issued                qty_allocated,
				qty_received			  qty_issued,
				qty_outstanding,
				0                          qty_purchased,
				0                          qty_received,
				null                       convert_fact,
				(qty_wh_req)               Dues_out_manual,
				'Dues out = SOH_Update_qty' formula,
				qty_wh_req 
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'Rx'
				and status = 'ALLC'
				and item_status = 'CMPL' 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				rcv_WhoUse_Id        wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				0                    qty_allocated,
				qty_issued,
				qty_outstanding,
				0                    qty_purchased,
				0                    qty_received,
				null                 convert_fact,
				(qty_req)            Dues_out_manual,
				'Dues out = qty_req' formula,
				qty_req				qty_wh_req
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'STRQ'
				and head.tran_type <> 'CRRT'
				and status = 'SBMT' 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				src_WhoUse_Id        wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				0                    qty_allocated,
				qty_issued,
				qty_outstanding,
				0                    qty_purchased,
				0                    qty_received,
				null                 convert_fact,
				(qty_req)            Dues_out_manual,
				'Dues out = qty_req' formula,
				qty_req				qty_wh_req
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'STTR'
				and status = 'SBMR' 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				src_WhoUse_Id        wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				0                    qty_allocated,
				qty_issued,
				qty_outstanding,
				0                    qty_purchased,
				0                    qty_received,
				null                 convert_fact,
				(qty_req)            Dues_out_manual,
				'Dues out = qty_req' formula,
				qty_req				qty_wh_req
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'STTR'
				and status in ('APRR','SBMT')
				and item.item_status not in ('CCLR','NARR') 
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL 
			select
				Stock_Code,
				src_WhoUse_Id        wh_id,
				Head.req_No,
				req_Type,
				Status,
				item.item_status,
				qty_req,
				0                    qty_allocated,
				qty_issued,
				qty_outstanding,
				0                    qty_purchased,
				0                    qty_received,
				null                 convert_fact,
				(qty_req)            Dues_out_manual,
				'Dues out = qty_req' formula,
				qty_req				qty_wh_req
			from
				kms.kms_supl_mtrl_trans_head head,
				kms.kms_supl_mtrl_trans_item item 
			where
				head.req_no = item.req_no
				and head.req_type = 'STTR'
				and status = 'APRV'
				and item.item_status in ('APPR','CMPL','CNCL')
				AND head.head_status_flag = 0
				AND item.item_status_flag = 0
			UNION ALL
			select
				comp.Stock_Code,
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
				0						qty_wh_req
			from
				kms.kms_supl_ppo_item item,
				kms.kms_supl_ppo_item_comp comp
			where
				item.prod_order_no = comp.prod_order_no
				and item.item_no = comp.item_no
				and item.status = 'NEW'
				and allocated = '1'
		) tbl_dues_out
		group by tbl_dues_out.stock_code, tbl_dues_out.wh_id) tbl_dues_out
on tbl_dues_out.stock_code=tbl_wh_inv.stock_code and tbl_dues_out.wh_id=tbl_wh_inv.whouse_id
where 
tbl_wh_inv.dues_out <> case when tbl_dues_out.Dues_out_manual is null then 0 else tbl_dues_out.Dues_out_manual end
order by tbl_wh_inv.whouse_id, tbl_wh_inv.stock_code