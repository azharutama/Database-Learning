USE
pra_UTS
GO

CREATE TABLE mahasiswa
(
    ID_Mahasiswa int PRIMARY KEY NOT NULL,
    nim          varchar(50)     NOT NULL,
    nama         varchar(50)     NOT NULL,
    alamat       varchar(50) NULL,
    kota         varchar(50) NULL
);

CREATE TABLE nilai
(
    nilai int,
    grade char(2)
);

CREATE TABLE matakuliah
(
    ID_matakuliah   int PRIMARY KEY not null,
    nama_matakuliah varchar(50)     not null,
    SKS             int             not null
);

CREATE TABLE perkuliahan
(
    ID_perkuliahan int PRIMARY KEY NOT NULL,
    ruangan        int NULL,


);

CREATE TABLE dosen
(
    ID_dosen int PRIMARY KEY NOT NULL,
    NIP      varchar(10)     NOT NULL,
    nama     varchar(50)     NOT NULL,
    alamat   varchar(50) NULL,
    kota     varchar(50) NULL


);

ALTER TABLE nilai
    ADD ID_mhs int;

ALTER TABLE nilai
    ADD ID_matkul int;

ALTER TABLE nilai
    ADD FOREIGN KEY (ID_mhs) REFERENCES mahasiswa (ID_Mahasiswa);

ALTER TABLE nilai
    ADD FOREIGN KEY (ID_matkul) REFERENCES matakuliah (ID_matakuliah);


ALTER TABLE perkuliahan
    ADD ID_mhs int NOT NULL;


ALTER TABLE perkuliahan
    ADD ID_matkul int NOT NULL;

ALTER TABLE perkuliahan
    ADD ID_dosen int NOT NULL;

ALTER TABLE perkuliahan
    ADD FOREIGN KEY (ID_mhs) REFERENCES mahasiswa (ID_Mahasiswa);

ALTER TABLE perkuliahan
    ADD FOREIGN KEY (ID_matkul) REFERENCES matakuliah (ID_matakuliah);

ALTER TABLE perkuliahan
    ADD FOREIGN KEY (ID_dosen) REFERENCES dosen (ID_dosen);

SELECT *
FROM mahasiswa;

INSERT INTO mahasiswa (ID_Mahasiswa, nim, nama, alamat, kota)
VALUES (1, '223040001', 'Nama Mahasiswa 1', 'Alamat 1', 'Jakarta'),
       (2, '223040002', 'Nama Mahasiswa 2', 'Alamat 2', 'Surabaya'),
       (3, '223040003', 'Nama Mahasiswa 3', 'Alamat 3', NULL),
       (4, '223040004', 'Nama Mahasiswa 4', 'Alamat 4', 'Cirebon'),
       (5, '223040005', 'Nama Mahasiswa 5', 'Alamat 5', 'Jakarta'),
       (6, '223040006', 'Nama Mahasiswa 6', 'Alamat 6', NULL),
       (7, '223040007', 'Nama Mahasiswa 7', 'Alamat 7', 'Pangandaran'),
       (8, '223040008', 'Nama Mahasiswa 8', 'Alamat 8', 'Cimahi'),
       (9, '223040009', 'Nama Mahasiswa 9', 'Alamat 9', NULL),
       (10, '223040010', 'Nama Mahasiswa 10', 'Alamat 10', 'Cimahi');

INSERT INTO dosen (ID_dosen, NIP, nama, alamat, kota)
VALUES (1, '040304001', 'Nama Dosen 1', 'Alamat Dosen 1', 'Bandung'),
       (2, '040304002', 'Nama Dosen 2', 'Alamat Dosen 2', 'Jakarta'),
       (3, '040304003', 'Nama Dosen 3', 'Alamat Dosen 3', 'Cimahi'),
       (4, '040304004', 'Nama Dosen 4', 'Alamat Dosen 4', 'Bandung');

INSERT INTO matakuliah (ID_matakuliah, nama_matakuliah, SKS)
VALUES (1, 'Matematika Informatika', 3),
       (2, 'Basis Data', 3),
       (3, 'Infrastruktur Jaringan', 2);

INSERT INTO nilai (ID_mhs, ID_matkul, nilai, grade)
VALUES (1, 1, 85, 'A'),
       (1, 2, 55, 'CD'),
       (1, 3, 80, 'AB'),
       (2, 1, 88, 'A'),
       (2, 2, 78, 'B'),
       (2, 3, 78, 'B'),
       (3, 1, 92, 'A'),
       (3, 2, 90, 'A'),
       (3, 3, 78, 'B'),
       (4, 1, 68, 'C'),
       (4, 2, 68, 'C'),
       (4, 3, 78, 'B'),
       (5, 1, 85, 'A'),
       (5, 2, 90, 'A'),
       (5, 3, 75, 'B'),
       (6, 1, 68, 'C'),
       (6, 2, 88, 'A'),
       (6, 3, 80, 'AB'),
       (7, 1, 85, 'A'),
       (7, 2, 68, 'C'),
       (7, 3, 75, 'B'),
       (8, 1, 0, 'T'),
       (8, 2, 0, 'T'),
       (8, 3, 0, 'T'),
       (9, 1, 55, 'CD'),
       (9, 2, 68, 'C'),
       (9, 3, 80, 'AB'),
       (10, 1, 50, 'D'),
       (10, 2, 50, 'D'),
       (10, 3, 50, 'D');

ALTER TABLE perkuliahan
DROP
COLUMN ruangan;

ALTER TABLE perkuliahan
    ADD ruangan varchar(50);

INSERT INTO perkuliahan (ID_perkuliahan, ID_mhs, ID_matkul, ID_dosen, ruangan)
VALUES (1, 1, 1, 1, 'SB410'),
       (2, 2, 1, 1, 'SB410'),
       (3, 3, 1, 1, 'SB410'),
       (4, 4, 1, 1, 'SB410'),
       (5, 5, 1, 1, 'SB410'),
       (6, 6, 1, 1, 'SB410'),
       (7, 7, 1, 1, 'SB410'),
       (8, 9, 1, 1, 'SB410'),
       (9, 10, 1, 1, 'SB410'),
       (10, 1, 2, 2, 'SB601'),
       (11, 2, 2, 2, 'SB601'),
       (12, 3, 2, 2, 'SB601'),
       (13, 4, 2, 2, 'SB601'),
       (14, 5, 2, 2, 'SB601'),
       (15, 6, 2, 2, 'SB601'),
       (16, 7, 2, 2, 'SB601'),
       (17, 9, 2, 2, 'SB601'),
       (18, 10, 2, 2, 'SB601'),
       (19, 1, 3, 3, 'SB603'),
       (20, 2, 3, 3, 'SB603'),
       (21, 3, 3, 3, 'SB603'),
       (22, 4, 3, 3, 'SB603'),
       (23, 5, 3, 3, 'SB603'),
       (24, 6, 3, 3, 'SB603'),
       (25, 7, 3, 3, 'SB603'),
       (26, 9, 3, 3, 'SB603'),
       (27, 10, 3, 3, 'SB603');

SELECT *
FROM perkuliahan;
