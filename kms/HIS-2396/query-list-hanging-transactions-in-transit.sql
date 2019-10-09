declare @TrxDate datetime
set @TrxDate='2019-08-09' 

--- In transit ---
select
	head.req_no,
	item.item_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',status,'EN')     status,
	stock_code,
	rcv_whouse_id                               wh_id,
	kms.getlookupdesc('SU_IST',item_status,'EN') item_status,
	qty_req,
	0                                           qty_allocated,
	qty_issued,
	qty_outstanding,
	0                                           qty_purchased,
	0                                           qty_received,
	null                                        convert_fact,
	qty_issued                                  qty,
	'stock in transit = qty_issued'             formula,
	qty_wh_req,
	rcv_whouse_id rcv_wh_id,
	src_whouse_id src_wh_id
from
	kms.kms_supl_mtrl_trans_item item,
	kms.kms_supl_mtrl_trans_head head 
where
	req_type = 'STTR'
	and item.req_no = head.req_no
	and status = 'INTR'
	and item_status = 'INTR'
	AND head.head_status_flag = 0
	AND item.item_status_flag = 0
	AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	and convert(date, head.req_date) <= @TrxDate
order by
	head.req_no,
	req_type