-- JOIN ---
-- Question 1
SELECT * FROM `Account` A JOIN `Department` D ON A.DepartmentID = D.DepartmentID
ORDER BY A.DepartmentID;
-- có thể order by A.DepID hoặc D.DepID đều đc

SELECT A.*, P.* FROM `Account` A JOIN `Position` P ON A.PositionID = P.PositionID
ORDER BY A.PositionID;
-- Question 2
SELECT A.fullName,A.DepartmentID,D.DepartmentName,A.PositionID,P.PositionName FROM `Account` A
JOIN `Department` D ON A.DepartmentID = D.DepartmentID
JOIN `Position` P ON A.PositionID = P.PositionID WHERE A.CreateDate > '2020-12-20';
-- Question 3: viết lệnh lấy ra tất cả các Deverloper
SELECT A.fullName,A.PositionID,P.PositionName FROM `Account` A
JOIN `Position` P ON A.PositionID = P.PositionID WHERE P.PositionName LIKE '%Dev%';
-- Question 4 Lấy ra danh sách phòng ban nhiều hơn 3 nhân viên
SELECT A.DepartmentID,D.DepartmentName, COUNT(D.DepartmentID) AS 'SoLuong' FROM `Account` A
JOIN `Department` D ON A.DepartmentID = D.DepartmentID GROUP BY (D.DepartmentID) HAVING SoLuong >= 3  ORDER BY A.DepartmentID;
-- Question 5 lấy ra danh sách câu hỏi đcsử dụng nhiều nhất 
SELECT EQ.QuestionID,Q.Content, COUNT(*) AS 'SL' FROM `ExamQuestion` EQ JOIN `Question` Q ON EQ.QuestionID=Q.QuestionID GROUP BY EQ.QuestionID
HAVING `SL` = (SELECT MAX(T.SL) FROM (SELECT QuestionID , COUNT(*) AS 'SL' FROM `ExamQuestion` GROUP BY QuestionID) AS T);

SELECT MAX(T.SL) FROM (SELECT QuestionID , COUNT(*) AS 'SL' FROM `ExamQuestion` GROUP BY QuestionID) AS T;

-- chi tiết cụ thể 
-- B1 : Đếm số lượng của từng QuestionID đc sdung trong để thi - theo QuestionID
SELECT QuestionID, COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID);
-- B2 lấy ra số lượng nhiều nhất
-- Cách 1: hàm Max()
SELECT MAX(`SL`) FROM (SELECT QuestionID, COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID)) AS `T`;
-- cách 2 ORDER BY ten_cot DESC LIMIT 1
SELECT  COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID) ORDER BY `SL` DESC LIMIT 1;
-- B3 lấy ra danh sách câu hoi sử dụng trong đề thi nhiều nhất 
SELECT QuestionID, COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID)
HAVING `SL` = (SELECT  COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID) ORDER BY `SL` DESC LIMIT 1);
-- lệnh này chỉ ra ID câu hỏi mà chưa có tên câu hỏi
-- sử dụng JOIN để lấy ra cụ thể 
SELECT Q.QuestionID, COUNT(Q.QuestionID) AS `SL`,Q.Content,q.CreatorID,Q.TypeID 
FROM ExamQuestion EQ JOIN Question Q ON EQ.QuestionID = Q.QuestionID GROUP BY (Q.QuestionID)
HAVING `SL` = (SELECT  COUNT(QuestionID) AS `SL` FROM ExamQuestion GROUP BY (QuestionID) ORDER BY `SL` DESC LIMIT 1);

-- Question 6 thống kê mỗi category question đc sdung trong bnhieu question
SELECT * FROM CategoryQuestion;
SELECT CQ.CategoryName,Q.CategoryID, COUNT(Q.CategoryID) AS `SL` FROM CategoryQuestion CQ 
LEFT JOIN `Question` Q ON CQ.CategoryID = Q.CategoryID
GROUP BY CQ.CategoryName;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT * FROM ExamQuestion;
SELECT Q.Content,Q.QuestionID, COUNT(EQ.QuestionID) FROM Question Q
LEFT JOIN ExamQuestion EQ ON EQ.QuestionID = Q.QuestionID
GROUP BY Q.QuestionID
ORDER BY EQ.ExamID DESC;

SELECT Q.Content,Q.QuestionID,COUNT(EQ.QuestionID) FROM Question Q
LEFT JOIN ExamQuestion EQ ON EQ.QuestionID = Q.QuestionID
GROUP BY Q.QuestionID
ORDER BY EQ.QuestionID DESC;                                    

-- Question 8:Lấy ra Question có nhiều câu tl nhất 
SELECT * FROM` Answer`;
SELECT A.Content,A.QuestionID, COUNT(Q.QuestionID) FROM Answer A
LEFT JOIN Question Q ON Q.QuestionID = A.QuestionID
GROUP BY A.QuestionID
ORDER BY A.Content LIMIT 1;

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT GA.GroupID,COUNT(A.AccountID) FROM GroupAccount GA
LEFT JOIN `Account` A ON GA.AccountID = A.AccountID
GROUP BY GA.GroupID
ORDER BY GA.GroupID DESC;

-- Question 10: Tìm chức vụ có ít người nhất 
SELECT P.PositionName, COUNT(A.PositionID) AS `SL` FROM `Account` A
LEFT JOIN Position P ON A.PositionID = P.PositionID
GROUP BY A.PositionID
ORDER BY A.PositionID DESC LIMIT 1;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM

SELECT D.DepartmentID,D.DepartmentName, P.PositionName, count(P.PositionName) AS `SL`  FROM `Account` A
INNER JOIN Department D ON A.DepartmentID = D.DepartmentID
INNER JOIN Position P ON A.PositionID = P.PositionID
GROUP BY D.DepartmentID, P.PositionID;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...
 SELECT Q.Content,TQ.TypeName,A.FullName,Q.QuestionID , ANS.Content
 FROM Question Q
 JOIN CategoryQuestion CQ ON Q.CategoryID = CQ.CategoryID
 JOIN TypeQuestion TQ ON Q.TypeID = TQ.TypeID
 JOIN `Account` A ON Q.CreatorID = A.AccountID
 JOIN `Answer` ANS ON Q.QuestionID = ANS.QuestionID
 ORDER BY Q.QuestionID ASC; 
-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm

SELECT TQ.TypeName,Q.TypeID, COUNT(Q.TypeID) AS `SL` FROM Question Q
JOIN TypeQuestion TQ ON Q.TypeID = TQ.TypeID
GROUP BY Q.TypeID ; 

-- -- Question 14 : lấy ra group k có account nào 
SELECT G.GroupName
FROM  `Group` G LEFT JOIN `GroupAccount` GA ON G.GroupID = GA.GroupID
WHERE GA.AccountID IS NULL;
-- Right join
SELECT G.GroupName
FROM  `GroupAccount` GA RIGHT JOIN `Group` G ON G.GroupID = GA.GroupID
WHERE GA.AccountID IS NULL;
-- Question 16: Lấy ra question không có answer nào
SELECT Q.QuestionID 
FROM Question Q LEFT JOIN Answer A ON Q.QuestionID = A.QuestionID
WHERE A.QuestionID IS NULL
ORDER BY Q.QuestionID;












