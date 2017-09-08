-- Task 17
BACKUP DATABASE SoftUni
TO DISK='E:\SoftUni\softuni-backup.bak'

RESTORE DATABASE SoftUni
FROM DISK='E:\SoftUni\softuni-backup.bak'