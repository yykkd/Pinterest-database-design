drop schema if exists Event_Management_47422024;

create schema Event_Management_47422024;
use Event_Management_47422024;

CREATE TABLE Department(
departmentId int auto_increment, 
departmentName varchar(30) UNIQUE, 
departmentDescription varchar(100),
PRIMARY KEY(departmentId)
);

CREATE TABLE PinterestUser(
userId int, 
firstName varchar(12) NOT NULL, 
lastName varchar(20), 
username varchar(15) NOT NULL, 
email varchar(50) UNIQUE NOT NULL, 
gender enum("M", "F"),
dateOfBirth date, 
dateOfJoining date,
PRIMARY KEY(userId)
);

CREATE TABLE BusinessUserType(
accountTypeId int auto_increment,
accountTypename varchar(50) NOT NULL UNIQUE,
PRIMARY KEY(accountTypeId)
);

CREATE TABLE BusinessUser(
userId int, 
about varchar(100), 
accountTypeId int, 
website varchar(100),
PRIMARY KEY(userId),
FOREIGN KEY(accountTypeId) references BusinessUserType(accountTypeId) On delete set null
);


CREATE TABLE Project(
projectId int, 
projectName varchar(50) NOT NULL UNIQUE, 
projectDescription varchar(100), 
projectBudget decimal(14, 2) NOT NULL, 
projectCommencementDate date, 
accountName varchar(50) NOT NULL, 
accountNumber bigint NOT NULL, 
moneyTransferred decimal(14, 2) NOT NULL,
paymentDate date,
PRIMARY KEY(projectId)
);

CREATE TABLE Interest(
interestId int auto_increment, 
interestName varchar(15) NOT NULL UNIQUE, 
interestDescription varchar(50),
PRIMARY KEY(interestId)
);

CREATE TABLE Employee(
employeeId int auto_increment, 
firstName varchar(12) NOT NULL, 
lastName varchar(20) NOT NULL, 
Ssn varchar(12) UNIQUE NOT NULL, 
email varchar(50) UNIQUE, 
departmentId int,
PRIMARY KEY(employeeId),
FOREIGN KEY Employee(departmentId) references Department(departmentId) On delete set null
);

CREATE TABLE Pin(
pinId int, 
title varchar(50),  
pinDescription varchar(100), 
scheduledDate date, 
userId int, 
interestId int,
PRIMARY KEY(pinId),
FOREIGN KEY Pin(userId) REFERENCES PinterestUser(userId) ON DELETE CASCADE,
FOREIGN KEY (interestId) REFERENCES Interest(interestId) ON DELETE SET NULL
);

CREATE TABLE ImagePin(
pinId int, 
altText varchar(100), 
destinationWebsite varchar(100),
FOREIGN KEY ImagePin(pinId) REFERENCES Pin(pinId) ON DELETE CASCADE
);

CREATE TABLE IdeaPin(
pinId int, 
noOfPages int, 
mediaType varchar(10),
FOREIGN KEY IdeaPin(pinId) REFERENCES Pin(pinId) ON DELETE CASCADE
);

CREATE TABLE Board(
boardId int, 
boardName varchar(50), 
boardPrivacy enum("private", "public") NOT NULL, 
boardDescription varchar(100), 
userId int NOT NULL,
PRIMARY KEY(boardId),
FOREIGN KEY Board(userId) REFERENCES PinterestUser(userId) ON DELETE CASCADE
);

CREATE TABLE CustomerService(
customerServiceCallId int auto_increment, 
dateOfCall date, 
complaint varchar(150) NOT NULL, 
resolved enum("yes", "no") NOT NULL, 
employeeId int, 
userId int,
PRIMARY KEY(customerServiceCallId),
FOREIGN KEY CustomerService(employeeId) REFERENCES Employee(employeeId),
FOREIGN KEY (userId) REFERENCES PinterestUser(userId)
);

CREATE TABLE Payment(
paymentId int, 
accountName varchar(50) NOT NULL, 
accountNumber bigint NOT NULL, 
moneyTransferred decimal(12, 2) NOT NULL, 
employeeId int,
paymentDate date,
PRIMARY KEY(paymentId),
FOREIGN KEY Payment(employeeId) REFERENCES Employee(employeeId)
);

CREATE TABLE ProjectEmployee(
employeeId int, 
projectId int,
FOREIGN KEY ProjectEmployee(employeeId) REFERENCES Employee(employeeId),
FOREIGN KEY (projectId) REFERENCES Project(projectId)
);

CREATE TABLE PinterestUserSavedPin(
pinId int, 
userId int,
FOREIGN KEY PinterestUserSavedPin(pinId) REFERENCES Pin(pinId),
FOREIGN KEY (userId) REFERENCES PinterestUser(userId)
);

CREATE TABLE PinterestUserInterest(
userId int, 
interestId int,
FOREIGN KEY PinterestUserInterest(userId) REFERENCES PinterestUser(userId),
FOREIGN KEY (interestId) REFERENCES Interest(interestId)
);

CREATE TABLE BoardPin(
boardId int, 
pinId int,
FOREIGN KEY BoardPin(boardId) REFERENCES Board(boardId),
FOREIGN KEY (pinId) REFERENCES Pin(pinId)
);

-- Because the acountNumber domain is bigint, it occupies more 
-- space. Also it must always be NOT NULL which means it might have more records.
-- Indexing will make the search for accountNumber easier
CREATE INDEX idx_accountnum
ON Payment (accountNumber);

-- Names are important for identifying a customer.
-- firstName is a required attribute meaning it may have more records than others
-- Indexing will make the search for firstName easier
CREATE INDEX idx_firstname
ON PinterestUser (firstName);

-- Emails are important for identifying a customer and communicating with them.
-- email is a required attribute meaning it may have more records than others
-- Indexing will make the search for email easier
CREATE INDEX idx_email
ON PinterestUser (email);

-- During customerService calls or after searching complainy records can be useful
-- for references and reviews.
-- Indexing will make the search for complaint easier
CREATE INDEX idx_complaint
ON CustomerService (complaint);

INSERT INTO Department
VALUES (1, 'Administration', 'Supports the smooth running of tasks and projectsin the company');
INSERT INTO Department
VALUES (2, 'Community Operations', 'Planning and developing programs that support  the overall growth  of the community');
INSERT INTO Department
VALUES (3, 'Customer Service', 'Interacts with customer to resolve problems pertaining to the use of the application');
INSERT INTO Department
VALUES (4, 'Philanthropy and Social Impact', 'Brainstorms and implements ideas on how the company can make social impact');
INSERT INTO Department
VALUES (5, 'Recruiting', 'Scouts for the best talents to work in the companu');


INSERT INTO PinterestUser 
VALUES (0262, 'Arvin', 'Bayfield', 'abayfield0', 'abayfield0@meetup.com', 'M' , '1991-08-10', '2021-12-30');
INSERT INTO PinterestUser 
VALUES (9412, 'Jennifer', 'Gribbins', 'jgribbins1', 'jgribbins1@timesonline.co.uk', 'F', '2002-06-19', '2002-07-08');
INSERT INTO PinterestUser
VALUES (7437, 'Avram', 'McGennis', 'amcgennis2', 'amcgennis2@cocolog-nifty.com', 'M', '2003-04-09', '2015-03-12');
INSERT INTO PinterestUser 
VALUES (4784, 'Giacomo', 'Kilford', 'gkilford3', 'gkilford3@edublogs.org', 'M', '1978-03-16', '2011-03-26');
INSERT INTO PinterestUser 
VALUES (5783, 'Sallie', 'MacGinney', 'smacginney4', 'smacginney4@irs.gov', 'F', '1982-09-12', '2022-01-18');

INSERT INTO BusinessUserType 
VALUES (1, "I'm not sure");
INSERT INTO BusinessUserType 
VALUES (2, 'Blogger');
INSERT INTO BusinessUserType 
VALUES (3, 'Consumer Good, Product, or Service');
INSERT INTO BusinessUserType 
VALUES (4, 'Contractor or Service Provider');
INSERT INTO BusinessUserType 
VALUES (5, 'Creator, Influencer, Public Figure or Celebrity');
INSERT INTO BusinessUserType 
VALUES (6, 'Institution/Non-Profit');
INSERT INTO BusinessUserType 
VALUES (7, 'Local Retail Store');
INSERT INTO BusinessUserType 
VALUES (8, 'Local Service');
INSERT INTO BusinessUserType 
VALUES (9, 'Online Retail or Marketplace');
INSERT INTO BusinessUserType 
VALUES (10, 'Publisher or Media');
INSERT INTO BusinessUserType 
VALUES (11, 'Other');

INSERT INTO BusinessUser
VALUES (5783, 'Fashion and Lifestyle', 5, 'http://reference.com/cursus/urna/');
INSERT INTO BusinessUser
VALUES (0262, 'Supporting the fight against cancer', 6, 'http://rakuten.co.jp/massa/volutpat/convallis/');

INSERT INTO Project
VALUES(8798, 'Global Creator Support',  null, 17000.00, '2018-02-27', 'GCS Program', 201827210771914, 17500.00, '2018-02-27');
INSERT INTO Project
VALUES(0076, 'Addicts Outreach Program', 'Supporting former addicts with training and jobs', 200000.00, '2022-11-07', 'Addicts Outreach Funding', 4175001984380021, 200000.00, '2022-11-07');
INSERT INTO Project
VALUES(9019, 'Pinterest University',  'Free learning materials for all employees who want to expand their knowledge on any subject', 1000000.00, '2021-01-01', 'PU Funds', 6706766132861543, 1000000.00, '2021-01-01');
INSERT INTO Project
VALUES(2339, 'Search Engine Optimization',  'Provide faster search results for users', 15000.00, null, 'SEO Tech',5602244962092890438, 15000.00, '2010-03-24');
INSERT INTO Project
VALUES(2019, 'Database Expansion',  null, 20000.00, null, 'DBE Tech', 374622094368056, 20000.00, '2011-09-30');

INSERT INTO Interest
VALUES(1, 'DIY Home Decor',  null);
INSERT INTO Interest
VALUES(2, 'Anime', 'Japanese Animation');
INSERT INTO Interest
VALUES(3, 'Music', null);
INSERT INTO Interest
VALUES(4, 'Crochet', 'Crochet items and crochet related activities');
INSERT INTO Interest
VALUES(5, 'Healthy Food', null);

INSERT INTO Employee
VALUES (1, 'Nedda', 'Boath', '469-11-8957', 'nboath0@ed.gov', 2);
INSERT INTO Employee
VALUES (2, 'Devan', 'Fenech', '204-59-6524', 'dfenech1@nps.gov', 3);
INSERT INTO Employee 
VALUES (3, 'Gaby', 'Sanford', '530-40-4235', 'gsanford2@irs.gov', 4);
INSERT INTO Employee 
VALUES (4, 'Maribelle', 'Escreet', '662-90-2055', 'mescreet3@umich.edu', 3);
INSERT INTO Employee
VALUES (5, 'Chicky', 'Bredbury', '119-42-5542', 'cbredbury4@hp.com',  1);
INSERT INTO Employee
VALUES (6, 'Yas', 'Dden', '881-484-185', 'ddeyas23@ppin.com', 3);


INSERT INTO Pin
VALUES(3988, 'Yas Loves', 'Grunge//cool #ootd', '2022-04-12', 5783, 4);
INSERT INTO Pin
VALUES(8340, 'Bottle to plant pot', 'Easy Diy. Only 4 materials needed', '2018-11-22', 4784,   1);
INSERT INTO Pin
VALUES(3894, 'Zoodles Recipe', null, '2021-07-14', 7437, 5);
INSERT INTO Pin
VALUES(9833, 'Metro Boomin Album Covers', '#latestdrops', '2022-12-04', 4784, 3);
INSERT INTO Pin
VALUES(4753, 'Greatest Scenes in Anime', 'For anime lovers', '2015-02-27', 9412, 2);

INSERT INTO ImagePin
VALUES (3988, 'Women wearing crochet top with grunge  aesthetic', null);
INSERT INTO ImagePin
VALUES (9833, 'Metro Boomin Album Covers over the previous years', 'https://www.boominatiworldwide.com/');

INSERT INTO IdeaPin
VALUES(8340, 1, 'mp4');
INSERT INTO IdeaPin
VALUES(3894, 2, 'mp4');
INSERT INTO IdeaPin
VALUES(4753, 5, 'mp4');

INSERT INTO Board
VALUES(903809, 'Outfit Ideas', 'public', 'Outfits for all occaisions and styles', 5783);
INSERT INTO Board 
VALUES(729818, 'My Anime For Life', 'public', 'All things Anime', 9412);
INSERT INTO Board 
VALUES(289101, 'DIY Plant Decor', 'public', null, 4784);
INSERT INTO Board 
VALUES(983728, 'Sexy substitutes for unhealthy meals', 'private', null, 7437);
INSERT INTO Board 
VALUES(194032, 'Music Album Covers', 'public', null, 4784);
INSERT INTO Board 
VALUES(903212, 'All things crochet', 'public', 'Crochet inspo', 0262);
INSERT INTO Board
VALUES(930133, 'Music <3', 'public', null, 9412);
INSERT INTO Board
VALUES(173901, 'Hip Hop Music', 'public', null, 0262);
INSERT INTO Board
VALUES(298201, 'Anime!', 'public', null, 4784);
INSERT INTO Board
VALUES(634811, 'Interior Design', 'public', null, 9412);


INSERT INTO CustomerService 
VALUES(1, '2013-09-26', 'Home feed not loading', 'yes', 2, 4784);
INSERT INTO CustomerService 
VALUES(2, '2022-12-04', 'Not getting a lot of saves on post', 'no', 4, 5783);
INSERT INTO CustomerService 
VALUES(3, '2017-09-26', 'Home feed not loading', 'yes', 2, 7437);
INSERT INTO CustomerService 
VALUES(4, '2022-12-02', 'Pin not saving to board', 'no', 6, 9412);
INSERT INTO CustomerService 
VALUES(5, '2022-12-03', 'Poor customer service', 'yes', 4, 9412);
INSERT INTO CustomerService 
VALUES(6, '2022-12-04', 'Pin not saving to board', 'yes', 4, 9412);
INSERT INTO CustomerService 
VALUES(7, '2022-12-05', 'Unable to navigate search results', 'no', 2, 0262);
INSERT INTO CustomerService 
VALUES(8, '2017-03-21', 'Cannot view saved pins', 'yes', 6, 0262);


INSERT INTO Payment
VALUES(0313, 'Nedda Boath', 374283651795379, 8000.00, 1, '2018-01-01');
INSERT INTO Payment
VALUES(8301, 'Gaby Stanford', 67634758750920676, 10000.00, 3, '2020-04-21');
INSERT INTO Payment
VALUES(0983, 'Yas Dden', 56109911552601205, 8000.00, 6, '2013-06-17');
INSERT INTO Payment
VALUES(8732, 'Devan Fenech', 675955725447301744, 12000.00, 2, '2022-09-11');
INSERT INTO Payment
VALUES(8921, 'Chicky Bredbury', 6394275121523731, 9000.00, 5, '2015-10-15');
INSERT INTO Payment
VALUES(0392, 'Nedda Boath', 374283651795379, 8000.00, 1, '2018-02-01');
INSERT INTO Payment
VALUES(8211, 'Maribelle Escreet', 374622124048322, 10000.00, 4, '2017-01-01');
INSERT INTO Payment
VALUES(2902, 'Yas Dden', 56109911552601205, 8000.00, 6, '2013-07-17');
INSERT INTO Payment
VALUES(9201, 'Devan Fenech', 675955725447301744, 12000.00, 2, '2022-10-11');
INSERT INTO Payment
VALUES(1091, 'Devan Fenech', 675955725447301744, 12000.00, 2, '2022-11-11');

INSERT INTO ProjectEmployee
VALUES(2, 8798);
INSERT INTO ProjectEmployee
VALUES(5, 2339);
INSERT INTO ProjectEmployee
VALUES(1, 0076);
INSERT INTO ProjectEmployee
VALUES(3, 9019);
INSERT INTO ProjectEmployee
VALUES(4, 8798);
INSERT INTO ProjectEmployee
VALUES(6, 2339);

INSERT INTO PinterestUserSavedPin
VALUES(3988, 0262);
INSERT INTO PinterestUserSavedPin
VALUES(9833, 9412); 
INSERT INTO PinterestUserSavedPin
VALUES(8340, 4784); 
INSERT INTO PinterestUserSavedPin
VALUES(9833, 0262);
INSERT INTO PinterestUserSavedPin
VALUES(4753, 4784);
INSERT INTO PinterestUserSavedPin
VALUES(8340, 9412);
INSERT INTO PinterestUserSavedPin
VALUES(9833, 4784); 
INSERT INTO PinterestUserSavedPin
VALUES(4753, 9412); 
INSERT INTO PinterestUserSavedPin
VALUES(3894, 7437);
INSERT INTO PinterestUserSavedPin
VALUES(3988, 5783);

INSERT INTO PinterestUserInterest
VALUES(0262, 3);
INSERT INTO PinterestUserInterest
VALUES(9412, 2);
INSERT INTO PinterestUserInterest
VALUES(7437, 5);
INSERT INTO PinterestUserInterest
VALUES(4784, 1);
INSERT INTO PinterestUserInterest
VALUES(4784, 3);
INSERT INTO PinterestUserInterest
VALUES(5783, 4);
INSERT INTO PinterestUserInterest
VALUES(9412, 5);
INSERT INTO PinterestUserInterest
VALUES(0262, 5);
INSERT INTO PinterestUserInterest
VALUES(4784, 5);
INSERT INTO PinterestUserInterest
VALUES(7437, 1);

INSERT INTO BoardPin
VALUES(903809, 3988);
INSERT INTO BoardPin
VALUES(729818, 4753);
INSERT INTO BoardPin
VALUES(289101, 8340);
INSERT INTO BoardPin
VALUES(983728, 3894);
INSERT INTO BoardPin
VALUES(194032, 9833);
INSERT INTO BoardPin
VALUES(903212, 3988);
INSERT INTO BoardPin
VALUES(930133, 9833);
INSERT INTO BoardPin
VALUES(173901, 9833);
INSERT INTO BoardPin
VALUES(729818, 4753);
INSERT INTO BoardPin
VALUES(298201, 4753);


-- selects all board and pin saved in board given a user
SELECT *
FROM BoardPin
WHERE boardId IN(
	SELECT boardId
	FROM Board 
	WHERE userId = 4784);
    
    
-- Selects most recent projects 
SELECT Project.projectName, Project.projectBudget
FROM Project 
ORDER BY(projectCommencementDate) desc
LIMIT 3;

    

-- Selects all customer service complaints that werent solved along with user info
SELECT PinterestUser.firstName, PinterestUser.lastName, PinterestUser.email, CustomerService.complaint
FROM PinterestUser
INNER JOIN CustomerService
ON PinterestUser.userId = CustomerService.userId;


-- get first name and last name and payment
 SELECT DISTINCT firstName, LastName, accountNumber
 FROM Employee
 LEFT OUTER JOIN Payment
 ON Employee.employeeId = Payment.employeeId;
 
 -- check for employees who have been paid earn more than 1000
 SELECT COUNT(moneyTransferred)
 FROM Payment
 WHERE moneyTransferred >= 10000;
 
 -- Selects all users that like a particular interest
SELECT userId
FROM pinterestUserInterest
WHERE interestId = 5; 
