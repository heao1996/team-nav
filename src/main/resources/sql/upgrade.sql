/*1.X自动升级2.0矫正脚本，仅执行一次*/
/*生成角色*/
INSERT INTO TEAM_NAV.NAV_ROLE(ID, ROLE_NAME, UPDATE_TIME)
SELECT '1', '管理员', NOW() WHERE NOT EXISTS (SELECT 1 FROM TEAM_NAV.NAV_ROLE WHERE ID='1');

INSERT INTO TEAM_NAV.NAV_ROLE_USER(ID, ROLE_ID, USER_ID)
SELECT '1', '1', '1' WHERE NOT EXISTS (SELECT 1 FROM TEAM_NAV.NAV_ROLE_USER WHERE ID='1');

/*迁移账号*/
DELETE FROM TEAM_NAV.NAV_USER;
INSERT INTO TEAM_NAV.NAV_USER(ID, AVATAR, NICK_NAME, PASSWORD, STATUS, UPDATE_TIME, USER_NAME)
SELECT C_ID, C_AVATAR, C_NICKNAME, C_PASSWORD, '1', NOW(), C_USERNAME
FROM PUBLIC.T_USER;

/*迁移系统设置*/
DELETE FROM TEAM_NAV.NAV_SETTING;
INSERT INTO TEAM_NAV.NAV_SETTING(ID, CUT_OVER_SPEED, LOGO_PATH, LOGO_TO_FAVICON, NAV_NAME, NGINX_OPEN, NGINX_URL)
SELECT C_ID, N_CUTOVER_SPEED, C_LOGO_PATH, C_LOGO_TO_FAVICON, C_NAV_NAME, C_NGINX_OPEN, C_NGINX_URL
FROM PUBLIC.T_SETTING;


/*迁移通知公告*/
DELETE FROM TEAM_NAV.NAV_NOTICE;
INSERT INTO TEAM_NAV.NAV_NOTICE(ID, CONTENT, END_TIME, SORT)
SELECT C_ID, C_CONTENT, DT_ENDTIME, N_SORT
FROM PUBLIC.T_NOTICE;

/*迁移卡片分类*/
DELETE FROM TEAM_NAV.NAV_CATEGORY;
INSERT INTO TEAM_NAV.NAV_CATEGORY(ID, ICON, "LEVEL", NAME, PID, SORT, UPDATE_TIME, VALID)
SELECT C_ID, 'dashboard', 1, C_NAME, '0', N_SORT, NOW(), N_VALID
FROM PUBLIC.T_CATEGORY;

INSERT INTO TEAM_NAV.NAV_ROLE_CATEGORY(ID, CATEGORY_ID, ROLE_ID)
SELECT REPLACE(UUID(),'-',''), C_ID, '1'
FROM PUBLIC.T_CATEGORY WHERE N_PRIVATE_CARD  = TRUE;

/*迁移卡片卡片*/
DELETE FROM TEAM_NAV.NAV_CARD;
INSERT INTO TEAM_NAV.NAV_CARD(
    ID, CATEGORY, CONTENT, HAS_ATTACHMENT, ICON, PRIVATE_CONTENT, SHOW_QRCODE, SORT, TITLE, "TYPE", URL, ZIP)
SELECT C_ID, C_CATEGORY, C_CONTENT, FALSE, C_ICON, '',CASE C_TYPE WHEN 'qrcode' THEN TRUE ELSE FALSE END AS SHOW_QRCODE,
       N_SORT, C_TITLE, CASE C_TYPE WHEN 'qrcode' THEN 'default' ELSE C_TYPE END AS "TYPE", C_URL, C_ZIP
FROM PUBLIC.T_CARD;
