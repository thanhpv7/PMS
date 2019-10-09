declare @TrxDate datetime
set @TrxDate='2019-08-09' 

--- Outstanding In	---
SELECT
	req_no,
	item_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',A.status,'EN')   status,
	stock_code,
	WhoUse_Id                                   wh_id,
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
	--outstanding_in                              qty,
	--formula,
	--qty_wh_req
FROM
	(
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		qty_outstanding                 outstanding_in,
		'Oustanding in = qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.outstanding_status = 'OT'
		AND head.req_type = 'STTR'
		AND head.status = 'RECV'		-- when store transfer is received
		AND item.item_status = 'TRFD'	-- for store transfer with status transferred only
		AND head.head_status_flag = 1
		AND item.item_status_flag = 1
		AND item.qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		last_qty_outstanding            outstanding_in,
		'Oustanding in = qty_outstanding = last_qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'SBMR'		-- when store transfer is submitted by requestor
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		last_qty_outstanding            outstanding_in,
		'Oustanding in = qty_outstanding = last_qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'APRR'		-- when store transfer is approved by requestor
		AND item.item_status = 'APRR'		-- for store transfer items with status approved by requestor only
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		last_qty_outstanding            outstanding_in,
		'Oustanding in = qty_outstanding = last_qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'SBMT'			-- when store transfer is submitted
		AND item.item_status NOT IN ('CCLR','NARR','SUBS')		-- for store transfer items that are not canceled/rejected by requestor
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		last_qty_outstanding            outstanding_in,
		'Oustanding in = last_qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'APRV'		-- when store transfer is approved
		AND item.item_status NOT IN ('CCLR','NARR','NAPR','SUBS')	-- for store transfer items that are not canceled/rejected by requestor and not rejected by sender
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.last_qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		qty_outstanding				  outstanding_in,
		'Oustanding in = qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'INTR'		-- when store transfer is in-transit
		AND item.item_status = 'INTR'	-- for store transfer items with status in-transit
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
		UNION ALL
	SELECT
		item.stock_code,
		item_no              item_no,
		head.rcv_whouse_id                whouse_id,
		head.req_no,
		req_type,
		status,
		item_status,
		qty_req,
		0                                 qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                 qty_purchased,
		0                                 qty_received,
		null                              convert_fact,
		qty_outstanding				  outstanding_in,
		'Oustanding in = qty_outstanding' formula,
		qty_wh_req,
		rcv_whouse_id rcv_wh_id,
		src_whouse_id src_wh_id
	FROM
		kms.kms_supl_mtrl_trans_head head,
		kms.kms_supl_mtrl_trans_item item
	WHERE
		head.req_no = item.req_no
		AND head.req_type = 'STTR'
		AND head.status = 'INTR'		-- when store transfer is in-transit
		AND item.item_status = 'TRFD'	-- for store transfer items with status transferred
		AND head.head_status_flag = 0
		AND item.item_status_flag = 0
		AND item.qty_outstanding > 0
	    AND (item.comp_medication IS NULL OR comp_medication < 1) --non-compound prescription
	    and convert(date, head.req_date) <= @TrxDate
	) A