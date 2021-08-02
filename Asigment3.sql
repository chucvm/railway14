-- question 3 : lấy ra id phòng ban sale
SELECT DepartmentID from Department
WHERE DepartmentName = 'Sale';

-- question 4: lấy người có FullName dài nhất 
SELECT * FROM `Account`
WHERE character_length(FullName)= (SELECT character_length(FullName) AS 'DoDai' from `Account` ORDER BY ('DoDai') DESC LIMIT 1);

SELECT * FROM `Account`
WHERE character_length(FullName)= (SELECT MAX( character_length(FullName)) AS 'DoDai' from `Account` ORDER BY ('DoDai') DESC LIMIT 1);
-- Question 5: lay ra tên dai nhat trong phong ban id = 3
SELECT * FROM `Account`
WHERE character_length(FullName)= (SELECT MAX( character_length(FullName)) AS 'DoDai' from `Account`WHERE DepartmentID = 3)
AND DepartmentID = 3;
 -- question 6: lấy ra group tham gia trước ngày 20/12/2019
 
 SELECT * FROM `Group`
 WHERE CreateDate <= '2019-12-20';
-- question 7:Lấy ra ID của question có >= 4 câu trả lời
SELECT * FROM Answer;
SELECT COUNT (a.QuestionID) FROM a.Answer
GROUP BY a.QuestionID
HAVING COUNT (a.QuestionID) >= 4;

-- question 8 :  Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày
-- 20/12/2019
SELECT * FROM Exam
WHERE Duration >= 60 AND CreateDate < '2019-12-20';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT * FROM `GroupAccount` 
ORDER BY JoinDate  DESC LIMIT 5;
 -- Question 10: Đếm số nhân viên thuộc department có id = 2
 SELECT COUNT(*) FROM `Account`
 WHERE DepartmentID = 2;
 -- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
 SELECT FullName FROM `Account`
 WHERE FullName LIKE 'D%o';
 -- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
 DELETE  FROM Exam
 WHERE CreateDate < '2019-04-05';
-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE FROM Question
WHERE Content LIKE 'Câu hỏi%';
-- question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và
-- email thành loc.nguyenba@vti.com.vn
UPDATE `Account`
SET FullName = 'Nguyễn Bá Lộc' , Email = 'loc.nguyenba@vti.com.vn'
WHERE AccountID = 5;

