SELECT whouse_id, stock_code, available, dues_out, allocated FROM kms.KMS_SUPL_WARH_INVN WHERE stock_code='OBTUH0025' and whouse_id='GF01'
SELECT req_no, status, outstanding_status, head_status_flag, unclaimed_by, unclaimed_date, queue_seq FROM kms.KMS_SUPL_MTRL_TRANS_HEAD WHERE req_no = 'P-1907040020' 
SELECT req_no, item_no, stock_code qty_issued, item_status, item_status_flag, qty_wh_req FROM kms.KMS_SUPL_MTRL_TRANS_ITEM WHERE req_no='P-1907040020'


SELECT * FROM kms.KMS_ADM_INVC_HEAD
SELECT * FROM kms.KMS_ADM_MEDC_ACTN WHERE actv_grp_id = '387'
SELECT * FROM kms.KMS_ADM_INVC_ITEM WHERE ref_id = 'P-1909170001'

SELECT * FROM kms.KMS_SUPL_WARH_INVN where stock_code='M00000005 ' and whouse_id='DIS'
SELECT * FROM kms.KMS_SUPL_ROPR_ITEM where order_no = '000000005'
SELECT * FROM kms.KMS_SUPL_MTRL_TRANS_HEAD where req_no='RQ0000014'
SELECT * FROM kms.KMS_SUPL_MTRL_TRANS_ITEM where req_no='RQ0000014'

select qty_req from kms.KMS_SUPL_MTRL_TRANS_ITEM where req_no='TR0000001' and stock_code='M00000010' and item_no=1 AND item_status_flag = 0

SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE'

SELECT TOP 10 * FROM kms.KMS_ADM_MEDC_ACTN where status = 'T'


--Purchase Order
SELECT * FROM kms.KMS_SUPL_WARH_INVN where stock_code='M00000005 ' and whouse_id='DIS'
SELECT * FROM kms.KMS_SUPL_ROPR_ITEM where order_no = (SELECT order_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no='1') and item_no = (SELECT order_item_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no='1')
SELECT * FROM kms.KMS_SUPL_PO_HEAD where po_no='000003'
SELECT * FROM kms.KMS_SUPL_PO_ITEM where po_no='000003' and po_item_no = '1'


-- dues-in
SELECT qty_approved * convert_fact FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no = '1' and status = 'AUTH'
-- ro
SELECT order_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and status = 'AUTH' and po_item_no = '1'
SELECT order_item_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and status = 'AUTH' and po_item_no = '1'
SELECT qty_approved * convert_fact FROM kms.KMS_SUPL_ROPR_ITEM where order_no = (SELECT order_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and status = 'AUTH' and po_item_no = '1') and item_no = (SELECT order_item_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and status = 'AUTH' and po_item_no = '1')


-- update RO KMS_SUPL_ROPR_ITEM
--update kms.KMS_SUPL_ROPR_ITEM set status = case when qty_req > qty_approved then 'PAPR' else 'AUTH' end where order_no = (SELECT order_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no='1') and item_no = (SELECT order_item_no FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no='1')
--update kms.KMS_SUPL_WARH_INVN
--set --dues_in=dues_in-(SELECT qty_approved * convert_fact FROM kms.KMS_SUPL_PO_ITEM where po_no='000004' and status = 'AUTH' and po_item_no = '1'),
--ro=ro+(select case when (select count(*) from kms.KMS_SUPL_ROPR_ITEM where order_no = (select order_no from kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no = '1' and status = 'AUTH') and item_no = (select order_item_no from kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no = '1' and status = 'AUTH')) > 0 then (select qty_approved * convert_fact from kms.KMS_SUPL_ROPR_ITEM where order_no = (select order_no from kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no = '1' and status = 'AUTH') and item_no = (select order_item_no from kms.KMS_SUPL_PO_ITEM where po_no='000004' and po_item_no = '1' and status = 'AUTH')) else 0 end),
--last_upd_date=getdate()
--where stock_code='M00000005' and whouse_id='DIS'


-- ro
SELECT * FROM kms.KMS_SUPL_WARH_INVN where stock_code='M00000050' and whouse_id='DIS'
SELECT * FROM kms.KMS_SUPL_ROPR_HEAD where order_no='000000007'
SELECT * FROM kms.KMS_SUPL_ROPR_ITEM where order_no='000000007'



