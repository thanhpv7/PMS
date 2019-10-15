declare @TrxDate datetime
set @TrxDate='2019-08-09' 

--- Outstanding Out	---
SELECT
    DISTINCT 
	req_no,
	item_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',A.status,'EN')   status,
	stock_code,
	whouse_id                                   wh_id,
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
	--outstanding_out                             qty,
	--formula,
	--qty_wh_req
FROM
	(
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding                outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
FROM
	kms.kms_supl_mtrl_trans_head head,
	kms.kms_supl_mtrl_trans_item item
WHERE
	head.req_no = item.req_no
	AND head.outstanding_status = 'OT'
	AND head.req_type = 'STTR'
	AND head.status = 'RECV'
	AND item.item_status = 'TRFD'
	AND head.head_status_flag = 1
	AND item.item_status_flag = 1
	AND item.qty_outstanding > 0
	AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	and convert(date, head.req_date) <= @TrxDate
UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.last_qty_outstanding           outstanding_out,
		'outstanding_out = qty_outstanding = last_qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'SBMR'
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.last_qty_outstanding           outstanding_out,
		'outstanding_out = qty_outstanding = last_qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'APRR'
		AND item.item_status = 'APRR'
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.last_qty_outstanding           outstanding_out,
		'outstanding_out = qty_outstanding = last_qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'SBMT'
		AND item.item_status NOT IN ('CCLR','NARR','SUBS')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
				
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.last_qty_outstanding           outstanding_out,
		'outstanding_out = last_qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'APRV'
		AND item.item_status NOT IN ('CCLR','NARR','NAPR','SUBS')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding				   outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'INTR'
		AND item.item_status = 'INTR'
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
			
UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.src_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		qty_issued                          qty_allocated,
		qty_received                        qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding                outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_req				qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'INTR'
		AND item.item_status = 'TRFD'
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		case when head.src_whouse_id is not null then head.src_whouse_id else head.rcv_whouse_id end whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		qty_issued				 			qty_allocated,
		qty_received						qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding				   outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'Rx'
		AND head.status <> 'NEW'
		AND item.item_status <> 'NEW'
		AND item.qty_outstanding > 0
		AND item.reserved = 'Y'
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		qty_issued				 			qty_allocated,
		qty_received						qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.last_qty_outstanding           outstanding_out,
		'outstanding_out = last_qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'Rx'
		AND head.status = 'SBMT'
		AND item.item_status NOT IN ('CNCL','NAPR','SUBS')
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                  whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		qty_issued				 			qty_allocated,
		qty_received						qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding           outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'Rx'
		AND ((head.status IN ('ALLC', 'PRTD') AND head.head_status_flag = 0 AND item.item_status_flag = 0)
			OR (head.status = 'ISSD' AND head.head_status_flag = 1 AND item.item_status_flag = 1))
		AND item.item_status NOT IN ('CNCL','NAPR','SUBS')
		AND item.qty_outstanding > 0
		AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
		and convert(date, head.req_date) <= @TrxDate
	) A

	UNION ALL
	SELECT
	    head.chart_no req_no,
		item.chart_item_no,
		kms.getlookupdesc('MDC_LIT', 'MDC', 'EN') as req_type_code,
		kms.getlookupdesc('MDC_LIT', 'MDC', 'EN') as req_type,
		kms.getlookupdesc('MDC_HEAD_STATUS',head.mode,'EN') status,
		item.stock_code,
		head.whouse_id                       whouse_id,
		kms.getlookupdesc('MDC_HEAD_STATUS',item.status,'EN') item_status,
		null,
		null
		--quantity,
		--0                                   qty_allocated,
		--qty_issued,
		--qty_outstanding,
		--0                                   qty_purchased,
		--0                                   qty_received,
		--null                                convert_fact,
		--item.qty_outstanding                outstanding_out,
		--'outstanding_out = qty_outstanding' formula,
		--qty_wh_req,
		--null,
		--null
	FROM
		kms.kms_serv_medc_chart head,
		kms.kms_serv_medc_chart_item item
	WHERE
		head.chart_no = item.chart_no
		AND head.outstanding_status = 'OT'
		AND head.mode IN ('ISSD', 'RECV', 'ADMD', 'RTRN', 'PRTR', 'FRTR', 'STOP')
		AND item.status IN ('ISSD', 'RECV', 'ADMD', 'RTRN', 'PRTR', 'FRTR', 'STOP')
		AND item.qty_outstanding > 0
	    and convert(date, head.order_date) <= @TrxDate