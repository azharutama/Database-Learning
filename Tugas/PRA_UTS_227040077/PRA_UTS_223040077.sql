USE PRA_UTS_223040077
GO

----I. Query Dasar
----1. Tuliskan Query tabel-tabel dari gambar ERD kemudian Tampilkan hasilnya di diagram Microsoft SQL server.----
----Untuk setiap PRIMARY KEY dan FOREIGN KEY gunakan perintah CONSTRAINT.-----
----Dan untuk setiap FOREIGN KEY gunakan perintah ON DELETE NO CASCADE ON UPDATE CASCADE.------

CREATE TABLE mahasiswa
(
    ID_Mahasiswa int         NOT NULL,
    nim          varchar(50) NOT NULL,
    nama         varchar(50) NOT NULL,
    alamat       varchar(50) ,
    kota         varchar(50) ,

    CONSTRAINT PK_MahasiswaID PRIMARY KEY (ID_Mahasiswa)


);



CREATE TABLE matakuliah
(
    ID_matakuliah   int         NOT NULL,
    nama_matakuliah varchar(50) NOT NULL,
    SKS             int         NOT NULL,

    CONSTRAINT PK_MatakuliahID PRIMARY KEY (ID_matakuliah)
);

CREATE TABLE nilai
(
    nilai                   int,
    grade                   char(2),
    MahasiswaID_Mahasiswa   int,
    MatakuliahID_Matakuliah int,

    FOREIGN KEY (MahasiswaID_Mahasiswa) REFERENCES mahasiswa (ID_Mahasiswa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (MatakuliahID_Matakuliah) REFERENCES matakuliah (ID_matakuliah) ON DELETE CASCADE ON UPDATE CASCADE,

);

CREATE TABLE perkuliahan
(
    ID_perkuliahan int NOT NULL,
    ruangan        int NULL,
    ID_Mahasiswa   int,
    ID_matakuliah  int,
    ID_Dosen       int,
    FOREIGN KEY (ID_Mahasiswa) REFERENCES mahasiswa (ID_Mahasiswa) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_matakuliah) REFERENCES matakuliah (ID_matakuliah) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_Dosen) REFERENCES dosen (ID_dosen) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_ID_PERKULIAHAN PRIMARY KEY (ID_perkuliahan)
);

CREATE TABLE dosen
(
    ID_dosen int         NOT NULL,
    NIP      varchar(10) NOT NULL,
    nama     varchar(50) NOT NULL,
    alamat   varchar(50) NULL,
    kota     varchar(50) NULL

        CONSTRAINT PK_ID_dosen PRIMARY KEY (ID_dosen)
);


ALTER TABLE perkuliahan
    DROP
        COLUMN ruangan;

ALTER TABLE perkuliahan
    ADD ruangan varchar(50);



----TUGAS II
-- 2. Manipulasi data menggunakan perintah ALTER, UPDATE, INSERT dan DELETE.
-- 	a) Tambahkan Constraint UNIQUE untuk NIM pada tabel Mahasiswa dan NIP pada Tabel Dosen.
-- 	b) Tambahkan kolom Email ber-Constraint UNIQUE untuk tabel Mhasiswa dan Dosesn.
-- 	c) Berikan CONSTRAINT CHECK untuk tabel Matakuliah agar nilai SKS lebih dari sama dengan 0 dan pada tabel Nilai agar tidak negatif dan tidak melebihi 100.
-- 	d) Masukkan Data dari file Data.txt menggunakan perintah INSERT INTO.
-- 	e) Pada tabel Mahasiswa tampilkan semua informasi kolom (hindari penggunaan wildcard(*)). Tampilkan semua data dimana alamat kota bernilai "null" tampilkan hasil querynya.
-- 	f) UPDATE alamat tabel Mahasiswa yang bernilai "null" menjadi "Bandung".
-- 	g) Hapus data Dosen yang memiliki NIP "04304004"-----


---A .Tambahkan Constraint UNIQUE untuk NIM pada tabel Mahasiswa dan NIP pada Tabel Dosen.----

USE PRA_UTS_223040077
GO

ALTER TABLE mahasiswa
    ADD CONSTRAINT UQ_Mahasiswa UNIQUE (nim);

ALTER TABLE dosen
    ADD CONSTRAINT UQ_Dosen UNIQUE (NIP);

-- 	b) Tambahkan kolom Email ber-Constraint UNIQUE untuk tabel Mhasiswa dan Dosesn.

ALTER TABLE mahasiswa
    ADD email varchar(50) not null;

ALTER TABLE mahasiswa
    ADD CONSTRAINT UC_Mahasiswa UNIQUE (email);

ALTER TABLE dosen
    ADD email varchar(50) not null;

ALTER TABLE dosen
    ADD CONSTRAINT UC_dosen UNIQUE (email);

-- 	c) Berikan CONSTRAINT CHECK untuk tabel Matakuliah agar nilai SKS lebih dari sama dengan 0 dan pada tabel Nilai agar tidak negatif dan tidak melebihi 100.


ALTER TABLE matakuliah
    ADD CONSTRAINT CK_SKS CHECK (SKS >= 0);


ALTER TABLE nilai
    ADD CONSTRAINT CK_Nilai CHECK (Nilai >= 0 AND Nilai <= 100);

-- 	d) Masukkan Data dari file Data.txt menggunakan perintah INSERT INTO.

--mahasiswa
INSERT INTO mahasiswa (ID_Mahasiswa, nim, nama, alamat, kota, email)
VALUES (1, '223040001', 'Nama Mahasiswa 1', 'Alamat 1', 'Jakarta', 'email1@example.com'),
       (2, '223040002', 'Nama Mahasiswa 2', 'Alamat 2', 'Surabaya', 'email2@example.com'),
       (3, '223040003', 'Nama Mahasiswa 3', 'Alamat 3', NULL, 'email3@example.com'),
       (4, '223040004', 'Nama Mahasiswa 4', 'Alamat 4', 'Cirebon', 'email4@example.com'),
       (5, '223040005', 'Nama Mahasiswa 5', 'Alamat 5', 'Jakarta', 'email5@example.com'),
       (6, '223040006', 'Nama Mahasiswa 6', 'Alamat 6', NULL, 'email6@example.com'),
       (7, '223040007', 'Nama Mahasiswa 7', 'Alamat 7', 'Pangandaran', 'email7@example.com'),
       (8, '223040008', 'Nama Mahasiswa 8', 'Alamat 8', 'Cimahi', 'email8@example.com'),
       (9, '223040009', 'Nama Mahasiswa 9', 'Alamat 9', NULL, 'email9@example.com'),
       (10, '223040010', 'Nama Mahasiswa 10', 'Alamat 10', 'Cimahi', 'email10@example.com');

SELECT ID_Mahasiswa, nim, nama, alamat, kota, email FROM mahasiswa;

--dosen
INSERT INTO dosen (ID_dosen, NIP, nama, alamat, kota, email)
VALUES (1, '040304001', 'Nama Dosen 1', 'Alamat Dosen 1', 'Bandung', 'dosen1@example.com'),
       (2, '040304002', 'Nama Dosen 2', 'Alamat Dosen 2', 'Jakarta', 'dosen2@example.com'),
       (3, '040304003', 'Nama Dosen 3', 'Alamat Dosen 3', 'Cimahi', 'dosen3@example.com'),
       (4, '040304004', 'Nama Dosen 4', 'Alamat Dosen 4', 'Bandung', 'dosen4@example.com');
SELECT ID_dosen, NIP, nama, alamat, kota, email
FROM dosen;

--matakuliah
INSERT INTO matakuliah (ID_matakuliah, nama_matakuliah, SKS)
VALUES (1, 'Matematika Informatika', 3),
       (2, 'Basis Data', 3),
       (3, 'Infrastruktur Jaringan', 2);
SELECT ID_matakuliah, nama_matakuliah, SKS
FROM matakuliah;

--nilai
INSERT INTO nilai (MahasiswaID_Mahasiswa, MatakuliahID_Matakuliah, nilai, grade)
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
SELECT *FROM nilai

INSERT INTO perkuliahan(ID_perkuliahan, ID_Mahasiswa, ID_matakuliah, ID_Dosen, ruangan)
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

SELECT * FROM perkuliahan

-- 	e) Pada tabel Mahasiswa tampilkan semua informasi kolom (hindari penggunaan wildcard(*)). Tampilkan semua data dimana alamat kota bernilai "null" tampilkan hasil querynya.

SELECT ID_Mahasiswa, nim, nama, alamat, kota, email
FROM mahasiswa;

use PRA_UTS_223040077
go
--f) UPDATE alamat tabel Mahasiswa yang bernilai "null" menjadi "Bandung".
UPDATE mahasiswa
SET kota = 'Bandung'
WHERE kota IS NULL;

--g) Hapus data Dosen yang memiliki NIP "04304004"

DELETE FROM Dosen
WHERE NIP = '04304004';


-- III. JOIN dan Set Operator
--
-- 3. Menggunakan fungsi Set Operator dan JOIN untuk menampilkan/menggabungkan data dari 2 atau lebih tabel yang berbeda.
-- 	a) Tampilkan semua nama Mahasiswa dan Dosen menggunakan SET OPERATOR
-- 	b) Tampilkan Kota yang ada Pada Dosen dan Mahasiswa
-- 	c) Tampilkan Kota Mahasiswa yang ada tidak ada pada Dosen
-- 	d) Tampilkan nama, NIM dan Nama Mata Kuliah untuk Mahasiswa yang mengambil mata kuliah tertentu (misalnya ID_MataKuliah = 1).
-- 	e) Tampilkan nama dan NIM mahasiswa yang tidak mengambil mata kuliah.---


---a) Tampilkan semua nama Mahasiswa dan Dosen menggunakan SET OPERATOR
SELECT Nama FROM Mahasiswa
UNION ALL
SELECT Nama FROM Dosen;

-- 	b) Tampilkan Kota yang ada Pada Dosen dan Mahasiswa

--- TANPA DUPLIKASI
SELECT DISTINCT Kota FROM Dosen
UNION
SELECT DISTINCT Kota FROM Mahasiswa;

--- DENGAN DUPLIKASI
SELECT Kota FROM Dosen
UNION ALL
SELECT Kota FROM Mahasiswa;


---c) Tampilkan Kota Mahasiswa yang ada tidak ada pada Dosen
SELECT DISTINCT Kota
FROM Mahasiswa
WHERE Kota NOT IN (SELECT DISTINCT Kota FROM Dosen);

---d) Tampilkan nama, NIM dan Nama Mata Kuliah untuk Mahasiswa yang mengambil mata kuliah tertentu (misalnya ID_MataKuliah = 1).
SELECT mahasiswa.Nama, mahasiswa.NIM, matakuliah.nama_matakuliah
FROM mahasiswa
JOIN nilai ON mahasiswa.ID_mahasiswa = nilai.MahasiswaID_Mahasiswa
JOIN mataKuliah ON nilai.MatakuliahID_Matakuliah = MataKuliah.ID_Matakuliah
WHERE matakuliah.ID_Matakuliah = 1;


---e) Tampilkan nama dan NIM mahasiswa yang tidak mengambil mata kuliah.---
SELECT Nama, NIM
FROM Mahasiswa
WHERE NOT EXISTS (
    SELECT 1
    FROM Nilai
    WHERE Nilai.MahasiswaID_Mahasiswa = Mahasiswa.ID_Mahasiswa
);


----
-- 4.Fungsi Agregat dan WINDOW FUNCTIONS
-- 	a) Hitung jumlah mahasiswa yang memiliki nilai lebih dari 80 (Fungsi Agregat).
-- 	b) Tampilkan Nama Mahasiswa dan Rata-rata Nilai (Fungsi Agregat).
-- 	c) Tampilkan Nama, NIM, ID Mahasiwa, Nilai dan ID Mata kuliah, kemudian lakukan perintah WINDOW FUNCTIONS untuk memberikan nilai rata-rata berdasarkan ID Matakuliah serta peringkat dengan dan tanpa loncatan berdasarkan ID Matakuliah yang diurutkan dari Nilai terbesar ke terkecil.
-- 	d) Buatlah urutan menggunakan ID Mata Kuliah dan buatkanlah kelompok 3 berdasarkan nilai Untuk matakuliah Basis Data.
-- ----

-- 	a) Hitung jumlah mahasiswa yang memiliki nilai lebih dari 80 (Fungsi Agregat).
SELECT COUNT(*) AS JumlahMahasiswa
FROM Mahasiswa
JOIN Nilai ON Mahasiswa.ID_Mahasiswa = Nilai.MahasiswaID_Mahasiswa
WHERE Nilai.nilai > 80;


-- 	b) Tampilkan Nama Mahasiswa dan Rata-rata Nilai (Fungsi Agregat).
SELECT Mahasiswa.Nama, AVG(Nilai.nilai) AS RataRataNilai
FROM Mahasiswa
JOIN Nilai ON Mahasiswa.ID_Mahasiswa = Nilai.MahasiswaID_Mahasiswa
GROUP BY Mahasiswa.ID_Mahasiswa, Mahasiswa.Nama;

---c) Tampilkan Nama, NIM, ID Mahasiwa, Nilai dan ID Mata kuliah, kemudian lakukan perintah WINDOW FUNCTIONS untuk memberikan nilai rata-rata berdasarkan ID Matakuliah serta peringkat dengan dan tanpa loncatan berdasarkan ID Matakuliah yang diurutkan dari Nilai terbesar ke terkecil.
SELECT
    Mahasiswa.Nama,
    Mahasiswa.NIM,
    Nilai.MahasiswaID_Mahasiswa AS ID_Mahasiswa,
    Nilai.nilai,
    Nilai.MatakuliahID_Matakuliah AS ID_Matakuliah,
    AVG(Nilai.nilai) OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah) AS RataRataNilai,
    ROW_NUMBER() OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah ORDER BY Nilai.nilai DESC) AS Peringkat,
    DENSE_RANK() OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah ORDER BY Nilai.nilai DESC) AS PeringkatTanpaLoncatan
FROM
    Mahasiswa
JOIN
    Nilai ON Mahasiswa.ID_Mahasiswa = Nilai.MahasiswaID_Mahasiswa
ORDER BY
    Nilai.MatakuliahID_Matakuliah, Nilai.nilai DESC;

--- d) Buatlah urutan menggunakan ID Mata Kuliah dan buatkanlah kelompok 3 berdasarkan nilai Untuk matakuliah Basis Data.
SELECT
    Mahasiswa.Nama,
    Mahasiswa.NIM,
    Nilai.MahasiswaID_Mahasiswa AS ID_Mahasiswa,
    Nilai.nilai,
    Nilai.MatakuliahID_Matakuliah AS ID_Matakuliah,
    AVG(Nilai.nilai) OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah) AS RataRataNilai,
    ROW_NUMBER() OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah ORDER BY Nilai.nilai DESC) AS Peringkat,
    DENSE_RANK() OVER (PARTITION BY Nilai.MatakuliahID_Matakuliah ORDER BY Nilai.nilai DESC) AS PeringkatTanpaLoncatan
FROM
    Mahasiswa
JOIN
    Nilai ON Mahasiswa.ID_Mahasiswa = Nilai.MahasiswaID_Mahasiswa
WHERE
    Nilai.MatakuliahID_Matakuliah = 2 -- ID Mata Kuliah untuk Basis Data
ORDER BY
    Nilai.MatakuliahID_Matakuliah, Nilai.nilai DESC;


---
-- 5.OUTPUT STATEMENT
--
-- 	a) Masukkan minimal 1 data Mahasiswa baru dan munculkanlah data yang baru tersebut
-- 	b) Hapus minimal 1 data Mahasiswa dan munculkanlah data yang terhapus tadi---

--- a) Masukkan minimal 1 data Mahasiswa baru dan munculkanlah data yang baru tersebut
INSERT INTO Mahasiswa (ID_Mahasiswa, nim, nama, alamat, kota, email)
VALUES (11, '223040077', 'Muhammad Azhar Utama', 'jl.galuga', 'bogor', 'azharutama.com'),
       (12, '223040085', 'Reza Ageng', 'jl.Hegarmana', 'jawa', 'reza@gmail.com'),
       (13, '223040086', 'Muhammad Azhar Lutfiadi', 'jl.gatau', 'subang', 'azharLutfiafi@gmail.com');

SELECT ID_Mahasiswa, nim, nama, alamat, kota, email FROM Mahasiswa;



-- 	b) Hapus minimal 1 data Mahasiswa dan munculkanlah data yang terhapus tadi---
DELETE FROM mahasiswa
WHERE ID_Mahasiswa = 11;

SELECT ID_Mahasiswa, nim, nama, alamat, kota, email FROM Mahasiswa;