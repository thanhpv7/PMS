SELECT whouse_id, stock_code, available, dues_out, allocated FROM kms.KMS_SUPL_WARH_INVN WHERE stock_code='OBTUH0025' and whouse_id='GF01'
SELECT req_no, status, outstanding_status, head_status_flag, unclaimed_by, unclaimed_date, queue_seq FROM kms.KMS_SUPL_MTRL_TRANS_HEAD WHERE req_no = 'P-1907040020' 
SELECT req_no, item_no, stock_code qty_issued, item_status, item_status_flag, qty_wh_req FROM kms.KMS_SUPL_MTRL_TRANS_ITEM WHERE req_no='P-1907040020'


SELECT * FROM kms.KMS_ADM_INVC_HEAD
SELECT * FROM kms.KMS_ADM_MEDC_ACTN WHERE actv_grp_id = '387'
SELECT * FROM kms.KMS_ADM_INVC_ITEM WHERE ref_id = 'P-1909170001'

--SELECT * FROM kms.KMS_SUPL_WARH_INVN where stock_code='M00000001' and whouse_id = 'MNWH'
SELECT * FROM kms.KMS_SUPL_WARH_INVN where stock_code='M00000001' and whouse_id = 'DIS'
SELECT * FROM kms.KMS_SUPL_MTRL_TRANS_HEAD where req_no='RQ0000014'
SELECT * FROM kms.KMS_SUPL_MTRL_TRANS_ITEM where req_no='RQ0000014'

select qty_req from kms.KMS_SUPL_MTRL_TRANS_ITEM where req_no='TR0000001' and stock_code='M00000010' and item_no=1 AND item_status_flag = 0

SELECT table_code FROM kms.KMS_CONF_SYST_LKUP WHERE table_type='SU_WID' AND status = 'ACTIVE'

SELECT TOP 10 * FROM kms.KMS_ADM_MEDC_ACTN where status = 'T'
