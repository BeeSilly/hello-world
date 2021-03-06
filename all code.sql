USE 'ht20_2_project_group_77';

CREATE TABLE IF NOT EXISTS User (
    PersonalNumber CHAR(12) NOT NULL UNIQUE,
    FirstName NVARCHAR(40) NOT NULL,
    LastName NVARCHAR(40) NOT NULL,
    Address NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Email NVARCHAR(50) NOT NULL UNIQUE,
    Passwords NVARCHAR(20) NOT NULL,
    Acceptnewsletter BOOL NOT NULL DEFAULT 0,
    PRIMARY KEY (PersonalNumber)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS DDepartment (
    DID CHAR(12) NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    ShortDescription NVARCHAR(100),
    Welcometext NVARCHAR(100),
    ParentDID CHAR(12),
    PRIMARY KEY (DID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

ALTER TABLE DDepartment 
	ADD FOREIGN KEY (ParentDID) REFERENCES DDepartment(DID);

CREATE TABLE IF NOT EXISTS Keyword (
    Keyword NVARCHAR(50) NOT NULL,
    PRIMARY KEY (Keyword)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS Product (
    PID CHAR(12) NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    ShortDescription NVARCHAR(100),
    VATPercent DOUBLE NOT NULL CHECK (VATPercent >= 0.0),
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    Discount DOUBLE NOT NULL DEFAULT 0.0 CHECK (Discount BETWEEN 0.0 AND 1.0),
    RetailPriceNoVAT DOUBLE NOT NULL CHECK (RetailPriceNoVAT >= 0.0),
    DID CHAR(12) NOT NULL,
    PRIMARY KEY (PID),
    FOREIGN KEY (DID)
        REFERENCES DDepartment (DID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS Contains (
    Keyword NVARCHAR(50) NOT NULL,
    PID CHAR(12) NOT NULL,
    PRIMARY KEY (Keyword , PID),
    FOREIGN KEY (PID)
        REFERENCES Product (PID),
    FOREIGN KEY (Keyword)
        REFERENCES Keyword (Keyword)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS Review (
    PID CHAR(12) NOT NULL,
    PersonalNumber CHAR(12) NOT NULL,
    Stars INT NOT NULL CHECK (Stars >= 1 AND Stars <= 5),
    TextComment NVARCHAR(500),
    PRIMARY KEY (PID , PersonalNumber),
    FOREIGN KEY (PID)
        REFERENCES Product (PID),
    FOREIGN KEY (PersonalNumber)
        REFERENCES User (PersonalNumber)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS Orders (
    OID CHAR(12) NOT NULL UNIQUE,
    OrderStatus ENUM('new', 'open', 'dispatched') NOT NULL,
    OrderDate DATE NOT NULL,
    LastChangeDate DATE NOT NULL CHECK (LastChangeDate >= OrderDate),
    PaymentReference VARCHAR(50),
    TrackingNumber VARCHAR(50),
    PersonalNumber CHAR(12) NOT NULL,
    PRIMARY KEY (OID),
    FOREIGN KEY (PersonalNumber)
        REFERENCES User (PersonalNumber)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE IF NOT EXISTS Includes (
    PID CHAR(12) NOT NULL,
    OID CHAR(12) NOT NULL,
    Quantity INT CHECK (Quantity >= 1),
    PRIMARY KEY (OID , PID),
    FOREIGN KEY (PID)
        REFERENCES Product (PID),
    FOREIGN KEY (OID)
        REFERENCES Orders (OID)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

CREATE TABLE Features(
    DID char(12),
    PID char(12),
    Primary key (DID, PID),
    FOREIGN KEY (PID) REFERENCES Product (PID),
    FOREIGN KEY (OID) REFERENCES Department(DID));

ALTER TABLE Features
    ADD FOREIGN KEY (PID) REFERENCES Product (PID),
    ADD FOREIGN KEY (DID) REFERENCES Department(DID);



INSERT INTO Department VALUES
    ('0', 'Homepage', 'Homepage for all the top department', 'Homepage', 'Welcome to the shopping mall', Null),
    ('1', 'Electronics', 'Electronics: PC, Phone, TV', 'Electronics', Null, '0'),
    ('2', 'Furnitures', 'Furnitures: Table, Chair, Sofa', 'Furnitures', Null, '0');

INSERT INTO User VALUES ('198005152315','Allen','Jaff','Täljstensvägen5ALgh1101,75240,Uppsala,Sweden','4612345678910','allen@gmail.com','allenjaff800515',0),
    ('198806166662','Ben','James',' WONGDAGGSTIGEN 4 B.14138. HUDDING.SWEDEN.','4612345241411','ben@gmail.com','james6662',1),
    ('196812172689','David','Stefan','Mojang AB - Söder Mälarstrand, Stockholm,.Sweden','4612345678911','david@gmail.com','stefan!2689',1);

INSERT INTO Features VALUES
    ('0', '1Gm6Ee3019dX'), ('0', 'C1'), ('0', 'C2'), ('0', 'Mwtl2Ln-A05F'), ('0', 'NS-43DF710na'),
    ('0', 'T1'), ('0', 'T2'), ('0', 'T3'), ('0', 'T4'), ('0', 'UN70TU6980fx');

INSERT INTO Department VALUES
    ('F1', 'Tables', 'Tables: Big tables, small tables', 'Many tables', NULL, '2'),
    ('FT1', 'Living Room Tables', 'Living room tables: sdfasdfas', 'Many living room tables', NULL, 'F1'),
    ('FT2', 'Outdoor Tables', 'Outdoor tables: sdfasdfas', 'Many outdoor tables', NULL, 'F1'),
    ('F2', 'Chairs', 'Chairs: Big chairs, small chairs', 'Many chairs', NULL, '2');

INSERT INTO Product VALUES
    ('T1', 'Fantastic dining table', 'Size: 10m * 10m. Quality: Great!!!', 'It is fantastic', 0.25, 10, 0, 99999, 'FT1'),
    ('T2', 'Small dining table', 'Size: 0.1m * 0.1m. Quality: Great!!!', 'It is small', 0.25, 100, 0, 9.9, 'FT1'),
    ('T3', 'Garden wood table', 'Size: 1.5m * 3m. Quality: Great!!!', 'Best for your garden!', 0.25, 100, 0, 999, 'FT2'),
    ('T4', 'Beach plastic table', 'Size: 1.5m * 3m. Quality: Great!!!', 'Best for beaches!', 0.25, 100, 0, 666, 'FT2'),
    ('C1', 'Gaming char', 'Quality: Great!!! Quality: Great!!! Quality: Great!!!', 'Best for gaming!', 0.25, 96, 0.2, 888, 'F2'),
    ('C2', 'Dining char', 'Quality: Great!!! Quality: Great!!! Quality: Great!!!', 'A boring dining char!', 0.25, 308, 0.1, 444, 'F2');

INSERT INTO Keyword VALUES
    ('lame'), ('fantastic'),('10/10'), ('table'),('chair'),
    ('small'),('big'),('wood'),('gaming'),('beach');

INSERT INTO Contains VALUES
    ('gaming', 'C1'), ('chair', 'C1'), ('10/10', 'C1'),('lame', 'C2'),('chair', 'C2'),
    ('fantastic', 'T1'), ('table', 'T1'), ('big', 'T1'), ('10/10', 'T1'),('fantastic', 'T2'),
    ('small', 'T2'), ('10/10', 'T2'), ('fantastic', 'T3'), ('wood', 'T3'), ('10/10', 'T3'),
	('beach', 'T4');

INSERT INTO Orders(OID, OrderStatus, OrderDate, LastChangeDate, PaymentReference, TrackingNumber, PersonalNumber) 
	VALUES
	('OD03','new','20201111','20201113','BOSW6610','ER503409141CS','198005152315'),
	('OD02','open','20201101',' 20201101','BODK7780','SF883409141SH','198806166662'),
	('OD01','dispatched','20201030','20201101','BONW8934','ST811345141NJ','196812172689');

INSERT INTO Includes(PID,OID,Quantity)
     VALUES
     ('1Gm6Ee3019dX','OD01','1'), ('Mwtl2Ln-A05F','OD01','1'),('NS-43DF710na','OD01','1'), 
     ('1Gm6Ee3019dX','OD02','2'), ('1Gm6Ee3019dX','OD03','3');

INSERT INTO Review(PID, PersonalNumber, Stars, TextComment)
     VALUES
     ('1Gm6Ee3019dX','196812172689','5','Mauris et ligula libero. Cras ornare ullamcorper mauris, id ullamcorper ex imperdiet et. Morbi ac tincidunt nisi. Integer sed gravida est. Vestibulum tempus consectetur purus, sed luctus risus vestibulum in. Aliquam tincidunt interdum purus. Quisque dolor arcu, varius sit amet lacus vitae, rutrum elementum mi.'),
     ('Mwtl2Ln-A05F','196812172689','2','Nam id scelerisque nunc, eu egestas lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque mauris risus, luctus vitae erat sit amet, iaculis lacinia eros. In hac habitasse platea dictumst. Pellentesque id ipsum a felis consectetur lacinia. Pellentesque imperdiet, dui sit amet gravida elementum, mi magna efficitur augue, eget pharetra enim turpis id nisi. Aliquam pellentesque vulputate dui, nec ullamcorper felis tincidunt quis. Etiam ac faucibus quam. Integer tincidunt diam nec ex rutrum ultrices. '),
     ('NS-43DF710na','196812172689','5','Praesent ac cursus libero. Pellentesque mattis nulla fermentum egestas vehicula. Aliquam commodo nisi dolor, in efficitur eros tempor eget. '),
     ('1Gm6Ee3019dX','198005152315','1',' Pellentesque porttitor volutpat elit, at consectetur lorem feugiat sed. Proin pharetra magna ut ante cursus pulvinar. In accumsan sapien sit amet elementum sollicitudin. Aenean eu porta mi. Aliquam bibendum non nibh at elementum. Donec ultrices consequat arcu ut suscipit.'),
     ('1Gm6Ee3019dX','198806166662','4','Nulla eleifend ligula id blandit ornare. Phasellus tincidunt, nisl ullamcorper consequat tincidunt, magna ligula euismod tellus, ac egestas sem turpis in lacus');

INSERT INTO Department values
	('E11', 'TV & Home Theater', 'TVs by size or type', 'TVs ', Null, 1),
	('E12', 'Computers', 'Laptops & Computer Components', 'Laptops and Desktops', Null, 1);

INSERT INTO Product values
	('UN70TU6980fx', 'Samsung LED UHD Smart Tizen TV', 'The HDR technology and 4K UHD resolution render sharp details and realistic colors', 'Samsung 4K UHD smart TV with a Crystal processor', 0.25, 133, 0.3, 5299, 'E11'),
	('NS-43DF710na', 'Insignia UHD Smart Fire TV', 'The 178-degree viewing angle allows comfortable watching', '43-inch Insignia Fire TV Edition television.', 0.25, 50, 0.2, 3599, 'E11'),
	('Mwtl2Ln-A05F', 'Apple - MacBook Air 13.3 256GB', 'The latest MacBook Air ', 'Available in silver, space gray, and gold.', 0.25, 88, 0.1, 13599, 'E12'),
	('1Gm6Ee3019dX', 'HP - Touch-Screen Laptop Nightfall Black', 'HP ENVY x360 convertible laptop', 'HP ENVY x360 Convertible 2-in-1 Laptop', 0.25, 264, 0.5, 8699, 'E12');

INSERT INTO Department values
	('E13','Cell Phones', 'Phones', 'CP', Null, 1);

INSERT INTO Review values
	('UN70TU6980fx', '198806166662', 4, 'Jufhuwl ahidh uhlaijf adw'),
	('UN70TU6980fx', '198005152315', 2, 'Adue hfuqo UHfoie fjo');

