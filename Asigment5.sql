SELECT * FROM `Account`;

DROP VIEW IF EXISTS `v_account_full_info`;
CREATE VIEW `v_account_full_info` AS 
SELECT A.*, DepartmentName,PositionName FROM `Account` A 
JOIN Department USING(DepartmentID)
JOIN Position USING (PositionID);
-- lay thong tin account cua phong marketing 
SELECT * FROM v_account_full_info WHERE departmentName = 'marketing';
-- lay thong tin cua account co chuc vu la Dev
SELECT * FROM v_account_full_info WHERE positionName = 'Dev';
-- question 1 Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE OR REPLACE VIEW `v_account_Sale` AS 
SELECT A.*, DepartmentName,PositionName FROM `Account` A 
JOIN Department USING(DepartmentID)
JOIN Position USING (PositionID) WHERE DepartmentName LIKE '%Sale%';

SELECT * FROM v_account_Sale;

-- Question 2 Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE OR REPLACE VIEW v_groupaccount_count AS
SELECT AccountID, COUNT(AccountID) AS `SL_Group_Tham_Gia` FROM `GroupAccount` GROUP BY(AccountID);

SELECT MAX(`SL_Group_Tham_Gia`) FROM v_groupaccount_count;

SELECT AccountID FROM v_groupaccount_count
WHERE SL_Group_Tham_Gia = (SELECT MAX(`SL_Group_Tham_Gia`) FROM v_groupaccount_count);

CREATE OR REPLACE VIEW `v_ac_group` AS
 SELECT * FROM `account`
 WHERE AccountID = (SELECT AccountID FROM v_groupaccount_count WHERE SL_Group_Tham_Gia = (SELECT MAX(`SL_Group_Tham_Gia`) FROM v_groupaccount_count));

SELECT * FROM `v_ac_group`;
-- Dùng CTE 
WITH CTE_Account AS
(
SELECT A.*, DepartmentName,PositionName FROM `Account` A 
JOIN Department USING(DepartmentID)
JOIN Position USING (PositionID)
)
SELECT * FROM CTE_Account;
-- Question 3 Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
-- được coi là quá dài) và xóa nó đi

CREATE OR REPLACE VIEW `Content_duoi_300_tu` AS
SELECT * FROM Question
WHERE length(Content) >= 300;

SELECT * FROM `Content_duoi_300_tu`;
-- lenh xóa 
DELETE FROM  `Content_duoi_300_tu`;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất 
CREATE OR REPLACE VIEW `v_pb_nhieu_nv_nhat` AS
SELECT A.DepartmentID,D.DepartmentName, COUNT(A.DepartmentID) AS `SL` FROM `Account` A
  JOIN Department D ON A.DepartmentID = D.DepartmentID GROUP BY A.DepartmentID
  HAVING count(A.DepartmentID) = (SELECT MAX(countDEP_ID) AS maxDEP_ID FROM
(SELECT count(A1.DepartmentID) AS countDEP_ID FROM account A1
GROUP BY A1.DepartmentID) AS TB_countDepID)
  ORDER BY DepartmentID LIMIT 1;
  
  SELECT * FROM `v_pb_nhieu_nv_nhat`;

-- CTE 
WITH CTE_pb_nhieu_nv_nhat AS
(
SELECT A.DepartmentID,D.DepartmentName, COUNT(A.DepartmentID) AS `SL` FROM `Account` A
  JOIN Department D ON A.DepartmentID = D.DepartmentID GROUP BY A.DepartmentID
  HAVING count(A.DepartmentID) = (SELECT MAX(countDEP_ID) AS maxDEP_ID FROM
(SELECT count(A1.DepartmentID) AS countDEP_ID FROM account A1
GROUP BY A1.DepartmentID) AS TB_countDepID)
  ORDER BY DepartmentID LIMIT 1
  )
SELECT * FROM CTE_pb_nhieu_nv_nhat;

-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
CREATE OR REPLACE VIEW `v_User_ho_Nguyen` AS
SELECT Q.CreatorID,A.FullName,Q.Content FROM Question Q 
JOIN `Account` A ON Q.CreatorID = A.AccountID
WHERE A.FullName LIKE 'Nguyễn%';

SELECT * FROM `v_User_ho_Nguyen`;

-- CTE
WITH CTE_User_ho_Nguyen AS
(
SELECT Q.CreatorID,A.FullName,Q.Content FROM Question Q 
JOIN `Account` A ON Q.CreatorID = A.AccountID
WHERE A.FullName LIKE 'Nguyễn%'
)
SELECT * FROM CTE_User_ho_Nguyen;









