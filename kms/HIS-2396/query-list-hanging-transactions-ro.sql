declare @TrxDate datetime
set @TrxDate='2019-12-09' 

--- RO ----
select
	head.order_no                                    req_no,
	item.item_no,
	--item.stock_code,
	--rcv_whouse_id                                    wh_id,
	req_type                                         req_type_code,
	kms.getlookupdesc('SU_POT',head.req_type,'EN')   req_type,
	kms.getlookupdesc('SU_POST',head.status,'EN')    status,
	Stock_Code,
	rcv_whouse_id                                    wh_id,
	kms.Getlookupdesc('SU_PRIST',item.status ,'EN') item_status
	--qty_req,
	--0                                                qty_allocated,
	--0                                                qty_issued,
	--0                                                qty_outstanding,
	--qty_purch                                        qty_purchased,
	--0                                                qty_received,
	--convert_fact,
	--item.qty_req * convert_fact                       qty,
	--'RO = item.qty_req * convert_fact'               formula, 
	--qty_req											 qty_wh_req
from
	kms.kms_supl_ropr_head head,
	kms.kms_supl_ropr_item item 
where
	head.order_no = item.order_no
	and req_type = 'RO'
	AND head.status = 'AUTH'
	AND item.status in ('AUTH','POCT')
	and item.qty_purch = 0
	and item.qty_req <> 0
	and convert(date, head.created_date) <= @TrxDate
