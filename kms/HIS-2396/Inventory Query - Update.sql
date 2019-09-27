--- Search query ---
select 
catl.stock_code, 
catl.STOCK_NAME, 
invn.whouse_id, 
invn.stk_on_hand, 
invn.stk_in_transit, 
invn.dues_in,
invn.dues_out, 
invn.outstanding_in, 
invn.outstanding_out, 
invn.ro, 
invn.available, 
invn.min_level
FROM 
kms.KMS_SUPL_WARH_INVN invn, kms.KMS_SUPL_STCK_CATL catl
where 1=1
and invn.stock_code = catl.stock_code
--and invn.whouse_id IN (?)
--and catl.stock_code = 'ATK_001'
;

--- stock code ---
select 
warhinvn0_.stock_code , 
warhinvn0_.whouse_id , 
warhinvn0_.stk_on_hand , 
warhinvn0_.stk_in_transit , 
warhinvn0_.val_on_hand , 
warhinvn0_.val_in_transit , 
warhinvn0_.val_on_hand_2 , 
warhinvn0_.val_in_transit_2 , 
warhinvn0_.dues_in , 
warhinvn0_.dues_out , 
warhinvn0_.available , 
warhinvn0_.ro , 
warhinvn0_.allocated , 
warhinvn0_.last_upd_by ,
warhinvn0_.last_upd_date , 
warhinvn0_.min_level , 
warhinvn0_.max_level , 
warhinvn0_.outstanding_out , 
warhinvn0_.outstanding_in , 
warhinvn0_.notes , 
warhinvn0_.min_threshold , 
warhinvn0_.max_preset , 
warhinvn0_.min_pct , 
warhinvn0_.min_threshold_pct , 
warhinvn0_.max_preset_pct  
from kms.KMS_SUPL_WARH_INVN warhinvn0_ 
where 1=1
--and warhinvn0_.stock_code=? 
--and warhinvn0_.whouse_id=?
;

--- SOH ---
SELECT  whouse_id, 
  			stock_code,
  			req_no, 
  			req_type,
            req_type_code,
			tran_type,
  			item_status, 
  			trans_date, 
  			deltaSOH, 
  			trans_type,
  			ref_id
		FROM
        (
        -- SOH out from immediate transfer of store transfer
        SELECT  head.src_whouse_id whouse_id ,
                item.stock_code              ,
                item.req_no                  ,
                kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				'' as tran_type,	
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
				CASE 
					WHEN item.received_date IS NOT NULL THEN item.received_date 
					ELSE head.received_date 
				END trans_date, 
                qty_issued deltaSOH          ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE
        	item.stock_code = 'AKABMA001'
    		AND head.src_whouse_id  = 'OUWH'     
        	AND item.req_no      = head.req_no
            AND item.item_status ='TRFD'
            AND head.req_type    ='STTR'
                -- use static date (change to appropriate date)
            AND (
            	(head.status = 'RECV' AND head.head_status_flag = 1 AND item.item_status_flag = 1 AND head.received_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY'))))
            	OR 
            	(head.status = 'INTR' AND head.head_status_flag = 0 AND item.item_status_flag = 0 AND item.received_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY'))))
            	OR
            	(head.status = 'APRV' AND head.head_status_flag = 0 AND item.item_status_flag = 0)
            	)
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.received_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- SOH out from store transfer acquitition
        SELECT  head.src_whouse_id whouse_id  ,
                item.stock_code               ,
                item.req_no                   ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				'' as tran_type,	
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.received_date trans_date ,
                qty_issued deltaSOH           ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE  
        	item.stock_code = 'AKABMA001'
    		AND head.src_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND item.item_status ='INTR'
            AND head.status      = 'INTR'
            AND head.req_type    ='STTR'
            AND head.head_status_flag = 0
            AND item.item_status_flag = 0
                -- use static date (change to appropriate date)
            AND head.acquitted_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.acquitted_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- SOH out from store requisition (normall issued and sell to third party)
        SELECT  head.rcv_whouse_id whouse_id  ,
                item.stock_code               ,
                item.req_no                   ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				kms.getLookupDesc('SU_TRT', head.tran_type, 'EN') as tran_type,			                  
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.acquitted_date trans_date,
                qty_issued deltaSOH           ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE 
        	item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'    
        	AND item.req_no      = head.req_no
            AND head.req_type    = 'STRQ'
            AND head.tran_type  IN ('NISS', 'STTP', 'EXP')
            AND item.item_status ='TRFD'
            AND head.status      = 'RECV'
            AND head.head_status_flag = 1
            AND item.item_status_flag = 1
                -- use static date (change to appropriate date)
            AND head.acquitted_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
           
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.acquitted_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- SOH out from complete issued Prescription
        SELECT  head.rcv_whouse_id whouse_id  ,
                item.stock_code               ,
                item.req_no                   ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				'' as tran_type,
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.acquitted_date trans_date,
                qty_wh_req deltaSOH         ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
            item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND head.req_type    = 'Rx'
            AND item.item_status in ('ISSD','FRTR','PRTR')
            AND head.status      in ('ISSD','FRTR','PRTR')
            AND head.head_status_flag = 1
            AND item.item_status_flag = 1
            AND item.qty_wh_req <> 0
                -- use static date (change to appropriate date)
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        -- using last_upd_date instead of acquitted_date because acquitted date
        -- for prescription doesn't include the time part
        --and head.last_upd_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- SOH out from issued Prescription
        SELECT  head.rcv_whouse_id whouse_id ,
                item.stock_code              ,
                item.req_no                  ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				' ' as tran_type,
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.last_upd_date trans_date,
                qty_wh_req deltaSOH        ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
            item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND head.req_type    = 'Rx'
            AND item.item_status ='ISSD'
            AND head.status      in ('ALLC','PRTD')
            AND head.head_status_flag = 0
            AND item.item_status_flag = 0
                -- it might be not accurate, using last_upd_date in header
                -- because last_upd_date in item is new implementation
                -- use static date (change to appropriate date)
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.last_upd_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- SOH out from unclaimed compound Prescription item
        SELECT  head.rcv_whouse_id whouse_id ,
                item.stock_code              ,
                item.req_no                  ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				' ' as tran_type,
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.last_upd_date trans_date,
                qty_wh_req deltaSOH        ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
            item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND head.req_type    = 'Rx'
            AND item.item_status ='UNCL'
            AND head.status      ='UNCL'
			and item.comp_seq > 0
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
            
        UNION ALL
        
        -- SOH out from Inventory Adjusment
        SELECT  head.rcv_whouse_id whouse_id ,
                item.stock_code              ,
                item.req_no                  ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				kms.getLookupDesc('SU_ADJT', head.tran_type, 'EN') as tran_type,          
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.created_date trans_date ,
                qty_received deltaSOH     ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
        	item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no   = head.req_no
            AND head.req_type = 'IVAD'
            AND head.adjustment_type = 'MINUS' 
            AND qty_received       > 0
			AND head.status ='ADJS'
			AND item.item_status = 'ADJS'
			AND head.head_status_flag = 1
			AND item.item_status_flag = 1
                -- use static date (change to appropriate date)
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        
        UNION ALL
        
        SELECT  head.rcv_whouse_id whouse_id  ,
                item.stock_code               ,
                item.req_no                   ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				'' as tran_type,	
				kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
				CASE 
					WHEN item.received_date IS NOT NULL THEN item.received_date 
					ELSE head.received_date 
				END trans_date, 
                qty_issued deltaSOH           ,
                1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
            item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND item.item_status ='TRFD'
            AND head.req_type    ='STTR'
                -- use static date (change to appropriate date)
            AND (
            	(head.status = 'RECV' AND head.head_status_flag = 1 AND item.item_status_flag = 1 AND head.received_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY'))))
            	OR 
            	(head.status = 'INTR' AND head.head_status_flag = 0 AND item.item_status_flag = 0 AND item.received_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY'))))
            	OR
            	(head.status = 'APRV' AND head.head_status_flag = 0 AND item.item_status_flag = 0)
            	)
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.received_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        --group by item.stock_code, rcv_whouse_id, qty_issued
        
        UNION ALL
        
        -- soh in from store requisition (credit return)
        SELECT  head.rcv_whouse_id whouse_id   ,
                item.stock_code                ,
                item.req_no                    ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				kms.getLookupDesc('SU_TRT', head.tran_type, 'EN') as tran_type,			             
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.acquitted_date trans_date ,
                qty_issued deltaSOH            ,
                1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
        	item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no      = head.req_no
            AND head.req_type    = 'STRQ'
            AND head.tran_type   = 'CRRT'
            AND item.item_status ='TRFD'
            AND head.status      = 'RECV'
            AND head.head_status_flag = 1
            AND item.item_status_flag = 1
                --use static date (change to appropriate date)
            AND head.acquitted_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        --use dinamic date
        --only get all data after the last update date/time of backup data
        --and head.acquitted_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
        
        UNION ALL
        
        -- soh in from inventory adjusment 
        SELECT  head.rcv_whouse_id whouse_id ,
                item.stock_code              ,
                item.req_no                  ,
                kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				kms.getLookupDesc('SU_ADJT', head.tran_type, 'EN') as tran_type,
                kms.getlookupdesc('SU_IST',item.item_status,'EN') item_status,
                head.created_date trans_date ,
                qty_received deltaSOH        ,
                1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item,
                kms.kms_supl_mtrl_trans_head head
        WHERE 
        	item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'  
        	AND item.req_no   = head.req_no
            AND head.req_type = 'IVAD'
            AND head.adjustment_type = 'PLUS' 
            AND qty_received       > 0
			AND head.status='ADJS'
			AND item.item_status='ADJS'
			AND head.head_status_flag = 1
			AND item.item_status_flag = 1
                -- use static date (change to appropriate date)
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
                -- use dinamic date
                -- only get all data after the last update date/time of backup data
                --and head.created_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)
      
      	UNION ALL
      	
       -- soh in from GRN
		SELECT item.whouse_id whouse_id,
			   item.stock_code,
			   head.grn_no req_no,
			   kms.getlookupdesc('SU_RQT','POST','EN')   req_type,
			   'POST' req_type_code,
			   '' tran_type,
			   kms.getlookupdesc('SU_POIST',item_status,'EN') item_status,
			   date_recv trans_date,
			   item.act_qty_buy * item.convert_fact deltaSOH,
			   1 AS trans_type,
			   item.po_no ref_id
			   --kms.getlookupdesc('SU_RQT','POST','EN')   req_type,
			   
		FROM   kms.kms_supl_grn_head head
		       LEFT JOIN kms.kms_supl_grn_item item
		         ON head.grn_no = item.grn_no
		WHERE
		    item.stock_code = 'AKABMA001'
    		AND item.whouse_id  = 'OUWH'
			AND item.act_qty_buy > 0 
			AND head.date_recv >= 
            DATEADD(minute, 20, DATEADD(hour, 10,kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        	AND item.posted = 'Y'
                
               UNION ALL 
               
       -- SOH out from retail Pharmacy
        SELECT  head.rcv_whouse_id whouse_id ,
                item.stock_code              ,
                head.ref_id                  ,
                 kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
                head.req_type   req_type_code,
				' ' as tran_type,
				kms.getlookupdesc('SU_IST','CMPL','EN') as item_status,
                head.last_upd_date trans_date,
                qty_received deltaSOH        ,
                -1 AS trans_type,
                head.ref_id
        FROM    kms.kms_supl_mtrl_trans_item item ,
                kms.kms_supl_mtrl_trans_head head
        WHERE   
        	item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'
        	AND item.req_no      = head.req_no        	
            AND head.req_type    = 'RET'
                -- it might be not accurate, using last_upd_date in header
                -- because last_upd_date in item is new implementation
                -- use static date (change to appropriate date)
            AND item.last_update_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))
        -- use dinamic date
        -- only get all data after the last update date/time of backup data
        --and head.last_upd_date > (SELECT TOP 1 last_upd_date FROM kms.kms_supl_warh_invn_backup ORDER BY last_upd_date DESC)

                
               UNION ALL

        SELECT
                a.whouse_id,
                b.stock_code,
                a.chart_no as req_no,
                kms.getlookupdesc('MDC_LIT', 'MDC', 'EN') as req_type,
                'MDC' as req_type_code,
                '' as tran_type,
                kms.getlookupdesc('MDC_HEAD_STATUS',b.status,'EN') item_status,
                a.issue_date as trans_date,
                sum(b.qty_wh_req) as deltaSOH,
                -1 as trans_type,
                '' as ref_id
        FROM
                kms.KMS_SERV_MEDC_CHART a, kms.KMS_SERV_MEDC_CHART_ITEM b
        WHERE 
            b.stock_code = 'AKABMA001'
    		AND a.whouse_id  = 'OUWH'
            AND b.chart_no = a.chart_no
            AND b.status IN ('ISSD','ADMD','RTRN','FRTR','PRTR','RECV','STOP') AND b.qty_issued is not null
        GROUP BY a.whouse_id, b.stock_code, a.chart_no, b.status, a.issue_date
       
       	UNION ALL
	   /* Pharmay Order return */	       
		SELECT
			head.rcv_whouse_id,
			item.stock_code,
			head.return_no,
			kms.getlookupdesc('SU_RQT','PRET','EN')   req_type,
			'PRET' req_type_code,
			'' as tran_type,
			kms.getlookupdesc('MDC_ISSUE_STATUS',item_status,'EN') item_status,
			head.received_date trans_date, 
			item.qty_approved deltaSOH,
			1 AS trans_type,
			head.order_no
		FROM 
			kms.KMS_SUPL_PHAR_RTRN_HEAD head,
			kms.KMS_SUPL_PHAR_RTRN_ITEM item			
		WHERE   
			item.stock_code = 'AKABMA001'
    		AND head.rcv_whouse_id  = 'OUWH'
			AND head.return_no = item.return_no
			AND item.item_status in ('FRCV','PRCV')
			AND head.last_upd_date >= DATEADD(minute, 20, DATEADD(hour, 10, kms.fStringToDateWithFormat('10-05-2018 10:20','DD-MM-YYYY')))       
        ) inbound
ORDER BY trans_date ASC
;

--- In transit ---
select
	head.req_no,
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
	qty_wh_req 
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
	AND rcv_whouse_id = 'CSSD'
	AND stock_code = 'CSSD00001' 
order by
	head.req_no,
	req_type
;

--- Due in ---
SELECT
	x.req_no,
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
	CASE 
		WHEN req_Type = 'PORD' THEN kms.Getlookupdesc('SU_POIST',item_status ,'EN')
		WHEN req_Type = 'PP' THEN kms.Getlookupdesc('SU_PPO',item_status,'EN') 
		ELSE kms.Getlookupdesc('SU_IST',item_status ,'EN') 
	END item_status, 
	stock_code,wh_id,
	item_status,qty_req,
	qty_allocated,qty_issued,
	qty_outstanding,qty_purchased,
	qty_received,convert_fact,
	Dues_In_manual qty,
	formula,
	qty_wh_req 
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
	) x 
WHERE
	Dues_In_manual <> 0
	and X.wh_id = 'MNWH'  and X.stock_code = 'MED_00133'
	;

--- Due out ---
select
	X.req_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',X.status,'EN')   status,
	stock_code,
	wh_id,
	kms.Getlookupdesc('SU_IST',item_status ,'EN') item_status, 
	qty_req,
	qty_allocated,
	qty_issued,
	qty_outstanding,
	qty_purchased,
	qty_received,
	convert_fact,
	Dues_out_manual qty,
	formula,
	qty_wh_req 
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
) X 
where
	dues_out_manual <> 0
	and X.wh_id = 'MNWH'
	and X.stock_code = 'MED_00001'
	;

--- Outstanding In	---
SELECT
	req_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',A.status,'EN')   status,
	stock_code,
	WhoUse_Id                                   wh_id,
	kms.Getlookupdesc('SU_IST',item_status ,'EN') item_status,
	qty_req,
	qty_allocated,
	qty_issued,
	qty_outstanding,
	qty_purchased,
	qty_received,
	convert_fact,
	outstanding_in                              qty,
	formula,
	qty_wh_req
FROM
	(
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
		UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	) A
WHERE
	A.whouse_id = 'MNWH'
	and A.stock_code = 'M00000015'
;

--- Outstanding Out	---
SELECT
	req_no,
	req_type                                    req_type_code,
	kms.getlookupdesc('SU_RQT',req_type,'EN')   req_type,
	kms.getlookupdesc('SU_TST',A.status,'EN')   status,
	stock_code,
	whouse_id                                   wh_id,
	kms.Getlookupdesc('SU_IST',item_status ,'EN') item_status,
	qty_req,
	qty_allocated,
	qty_issued,
	qty_outstanding,
	qty_purchased,
	qty_received,
	convert_fact,
	outstanding_out                             qty,
	formula,
	qty_wh_req
FROM
	(
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
				
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
			
UNION ALL
	SELECT
		item.stock_code,
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
		qty_req				qty_wh_req
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
UNION ALL
	SELECT
		item.stock_code,
		head.src_whouse_id                  whouse_id,
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
		qty_wh_req
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
UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
UNION ALL
	SELECT
		item.stock_code,
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
		qty_wh_req
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
	UNION ALL
	SELECT
		item.stock_code,
		head.whouse_id                       whouse_id,
		head.chart_no,
		kms.getlookupdesc('MDC_LIT', 'MDC', 'EN') as req_type,
		kms.getlookupdesc('MDC_HEAD_STATUS',head.mode,'EN') status,
		kms.getlookupdesc('MDC_HEAD_STATUS',item.status,'EN') item_status,
		quantity,
		0                                   qty_allocated,
		qty_issued,
		qty_outstanding,
		0                                   qty_purchased,
		0                                   qty_received,
		null                                convert_fact,
		item.qty_outstanding                outstanding_out,
		'outstanding_out = qty_outstanding' formula,
		qty_wh_req
	FROM
		kms.kms_serv_medc_chart head,
		kms.kms_serv_medc_chart_item item
	WHERE
		head.chart_no = item.chart_no
		AND head.outstanding_status = 'OT'
		AND head.mode IN ('ISSD', 'RECV', 'ADMD', 'RTRN', 'PRTR', 'FRTR', 'STOP')
		AND item.status IN ('ISSD', 'RECV', 'ADMD', 'RTRN', 'PRTR', 'FRTR', 'STOP')
		AND item.qty_outstanding > 0
	) A
WHERE
	A.whouse_id = 'MNWH'
	and A.stock_code = 'MED_00004'
;
    
--- RO ----
select
	head.order_no                                    req_no,
	item.stock_code,
	rcv_whouse_id                                    wh_id,
	req_type                                         req_type_code,
	kms.getlookupdesc('SU_POT',head.req_type,'EN')   req_type,
	kms.getlookupdesc('SU_POST',head.status,'EN')    status,
	Stock_Code,
	rcv_whouse_id                                    wh_id,
	kms.Getlookupdesc('SU_PRIST',item.status ,'EN') item_status,
	qty_req,
	0                                                qty_allocated,
	0                                                qty_issued,
	0                                                qty_outstanding,
	qty_purch                                        qty_purchased,
	0                                                qty_received,
	convert_fact,
	item.qty_req * convert_fact                       qty,
	'RO = item.qty_req * convert_fact'               formula, 
	qty_req											 qty_wh_req
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
	and head.rcv_whouse_id = 'MNWH'
	and item.stock_code = 'MED_00058'
;

