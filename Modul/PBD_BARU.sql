USE PBD
GO

-----NAMA KELOMPOK
-- 1.REZA AGENG TRIHANDOKO(223040085)
-- 2.MUHAMMAD AZHAR UTAMA (223040077)
-- 3.VISI MUHAMMAD ISLAMI (223040075)
-- 4.MUHAMMAD RAFLY ALFARIZI (223040043)
-- 5.FLAVIO BONIPERTI OKTAVIOLA ZYOFFY(223040053)
-- ----


-------------------------CONSTRAINT-------------------------------

------Table gerai-----
CREATE TYPE Nama FROM VARCHAR(80);
CREATE TABLE dbo.Gerai
(
    Gerai_ID          INT         NOT NULL,
    Nama_cabang       [Nama]      NOT NULL,
    Tanggal_pembukaan DATETIME    NOT NULL,
    Alamat            VARCHAR(50) NOT NULL,
    Kelurahan         VARCHAR(50) NOT NULL,
    Kecamatan         VARCHAR(50) NOT NULL,
    kabupaten_kota    VARCHAR(50) NOT NULL,
    Provinsi          VARCHAR(60) NOT NULL,

    CONSTRAINT PK_Gerai PRIMARY KEY (Gerai_ID)
);


------Table Jabatan------
CREATE TABLE dbo.Jabatan
(
    Jabatan_ID   INT  NOT NULL,
    Nama_jabatan Nama NOT NULL,
    Deskripsi    TEXT NOT NULL,

    CONSTRAINT PK_Jabatan PRIMARY KEY (Jabatan_ID)
);


------Table Diskon------
CREATE TABLE dbo.Diskon
(
    Diskon_ID             INT           NOT NULL,
    Persen_Diskon         Numeric(5, 2) NOT NULL,
    Tanggal_awal_berlaku  DATETIME      NOT NULL,
    Tanggal_akhir_berlaku DATETIME      NOT NULL,
    MinQty                INT           NOT NULL,
    Deskripsi             TEXT          NOT NULL,

    CONSTRAINT CHK_MINqty CHECK (MinQty > 0),
    CONSTRAINT CHK_tgl_akhir CHECK (tanggal_akhir_berlaku > tanggal_awal_berlaku),
    CONSTRAINT CHK_persen_diskon CHECK (Persen_Diskon >= 0 AND Persen_Diskon <= 100),
    CONSTRAINT PK_Diskon PRIMARY KEY (Diskon_ID)
);

-----Table Supplier------
CREATE TABLE dbo.Supplier
(
    Supplier_ID    INT         NOT NULL,
    Nama_Supplier  Nama        NOT NULL,
    Alamat         VARCHAR(50) NOT NULL,
    Kelurahan      VARCHAR(50) NOT NULL,
    Kecamatan      VARCHAR(50) NOT NULL,
    Kabupaten_Kota VARCHAR(50) NOT NULL,
    Provinsi       VARCHAR(50) NOT NULL,
    No_Kontak      VARCHAR(15) NOT NULL

        CONSTRAINT CHK_Unique_No_Kontak UNIQUE,
    CONSTRAINT PK_Supplier PRIMARY KEY (Supplier_ID)
);

-----Table Jenis Member------

CREATE TABLE dbo.Jenis_member
(
    Jenis_Member_ID   INT         NOT NULL,
    Nama_jenis_member Nama        NOT NULL,
    Min_Trans         VARCHAR(80) NOT NULL,
    Deskripsi         TEXT        NOT NULL

        CONSTRAINT PK_JenisMember PRIMARY KEY (Jenis_Member_ID),

);


-------Table Member----
CREATE TABLE dbo.Member
(
    Member_ID                 INT         NOT NULL,
    No_KTP                    VARCHAR(16) NOT NULL,
    Nama_Member               Nama        NOT NULL,
    Jenis_kelamin             CHAR(1)     NOT NULL,
    Alamat                    VARCHAR(50) NOT NULL,
    Kelurahan                 VARCHAR(50) NOT NULL,
    Kecamatan                 VARCHAR(50) NOT NULL,
    Kabupaten_Kota            VARCHAR(50) NOT NULL,
    Provinsi                  VARCHAR(50) NOT NULL,
    tanggal_daftar_member     DATE        NOT NULL,
    tanggal_kadaluarsa_member DATE        NOT NULL,
    No_Kontak                 VARCHAR(15) NOT NULL,
    Jenis_Member_ID           INT         NOT NULL,

    CONSTRAINT CHK_no_ktp UNIQUE (No_KTP),
    CONSTRAINT CHK_no_kontak UNIQUE (No_Kontak),
    CONSTRAINT CHK_kelamin CHECK (Jenis_kelamin IN ('P', 'L')),
    CONSTRAINT FK_Member_JenisMember FOREIGN KEY (Jenis_Member_ID) REFERENCES Jenis_member (Jenis_Member_ID),
    CONSTRAINT PK_Member PRIMARY KEY (Member_ID)
);


-------Table Produk----
CREATE TABLE dbo.Produk
(
    Produk_ID          INT            NOT NULL,
    Nama_produk        Nama           NOT NULL,
    Jenis_produk       VARCHAR(20),
    tanggal_kadaluarsa DATE           NOT NULL,
    berat              DECIMAL(10, 2) NOT NULL,
    satuan_berat       VARCHAR(50)    NOT NULL,
    sumber_produk      VARCHAR(50)    NOT NULL,
    harga_satuan       MONEY NOT NULL,
    Supplier_ID        INT            NOT NULL,

    CONSTRAINT CHK_satuan_berat CHECK (satuan_berat IN ('G', 'Mg', 'Kg', 'L', 'Ml')),
    CONSTRAINT CHK_harga_satuan CHECK (harga_satuan > 0),
    CONSTRAINT FK_Produk_Supplier FOREIGN KEY (Supplier_ID) REFERENCES Supplier (Supplier_ID),
    CONSTRAINT PK_Produk PRIMARY KEY (Produk_ID)
);


--------Table Diskon produk----
CREATE TABLE dbo.Diskon_produk
(
    Diskon_produk_ID INT NOT NULL,
    Diskon_ID        INT NOT NULL,
    produk_ID        INT NOT NULL,
    CONSTRAINT FK_DiskonProduk_Diskon FOREIGN KEY (Diskon_ID) REFERENCES Diskon (Diskon_ID),
    CONSTRAINT FK_DiskonProduk_Produk FOREIGN KEY (Produk_ID) REFERENCES Produk (Produk_ID),
    CONSTRAINT PK_Diskon_produk PRIMARY KEY (Diskon_produk_ID)
);

------Table Pegawai-----
CREATE TABLE dbo.Pegawai
(
    Pegawai_ID         INT          NOT NULL,
    Nama_pegawai       Nama         NOT NULL,
    Jenis_kelamin      CHAR(1)      NOT NULL
        CONSTRAINT CHK_jenis_kelamin CHECK (Jenis_kelamin IN ('P', 'L')),
    Tanggal_lahir      DATE         NOT NULL,
    Tanggal_diterima   DATE         NOT NULL,
    Alamat             VARCHAR(50) NOT NULL,
    Kelurahan          VARCHAR(50) NOT NULL,
    Kecamatan          VARCHAR(50) NOT NULL,
    Kabupaten_Kota     VARCHAR(50) NOT NULL,
    Provinsi           VARCHAR(50) NOT NULL,
    Lulusan_pendidikan VARCHAR(50) NOT NULL,
    Honor              VARCHAR(50) NOT NULL,
    Status_pernikahan  VARCHAR(20) NOT NULL
        CONSTRAINT CHK_pernikahan CHECK (Status_pernikahan IN ('Nikah', 'Belum Nikah')), -- Menggunakan NVARCHAR untuk status pernikahan
    Jumlah_anak        INT          NOT NULL,

    Jenis_pegawai      INT          NOT NULL,
    Jabatan_ID         INT          NOT NULL,
    Gerai_ID           INT          NOT NULL,
    Atasan_ID          INT          NULL,
    CONSTRAINT CHK_jumlah_anak CHECK ((Status_pernikahan = 'Belum Nikah' AND Jumlah_anak = 0) OR
                                      (Status_pernikahan = 'Nikah' AND Jumlah_anak >= 0)),
    CONSTRAINT FK_Pegawai_Jabatan FOREIGN KEY (Jabatan_ID) REFERENCES Jabatan (Jabatan_ID),
    CONSTRAINT FK_Pegawai_Gerai FOREIGN KEY (Gerai_ID) REFERENCES Gerai (Gerai_ID),
    CONSTRAINT FK_Pegawai_Atasan FOREIGN KEY (Atasan_ID) REFERENCES Jabatan (Jabatan_ID),
    CONSTRAINT PK_Pegawai PRIMARY KEY (Pegawai_ID)
);

----table penjualan----

CREATE TABLE dbo.Penjualan
(
    No_transaksi      INT  NOT NULL,
    Tanggal_transaksi DATE NOT NULL,
    Total_pembayaran  INT  NOT NULL,
    Jenis_pembayaran  INT  NOT NULL,
    Member_ID         INT  NULL,
    Pegawai_ID        INT  NOT NULL,

    CONSTRAINT FK_Penjualan_Member FOREIGN KEY (Member_ID) REFERENCES Member (Member_ID),
    CONSTRAINT FK_Penjualan_Pegawai FOREIGN KEY (Pegawai_ID) REFERENCES Pegawai (Pegawai_ID),
    CONSTRAINT PK_Penjualan PRIMARY KEY (No_transaksi)
);


------table rincian penjualan------
CREATE TABLE dbo.Rincian_Penjualan
(
    Rincian_ID             INT            NOT NULL,
    No_transaksi           INT            NOT NULL,
    Produk_ID              INT            NOT NULL,
    Harga_satuan           MONEY NOT NULL
        CONSTRAINT CHK_harga_satuan_penjualan CHECK (Harga_satuan > 0),
    Kuantitas_penjualan    INT            NOT NULL,
    Diskon_produk_ID       INT            NOT NULL,
    Nominal_diskon         DECIMAL(10, 2) NULL
        CONSTRAINT CHK_Nominal_diskon CHECK (Nominal_diskon > 0),
    Total_biaya_per_produk AS (Harga_satuan * Kuantitas_penjualan) - COALESCE(Nominal_diskon, 0) PERSISTED,
    CONSTRAINT CHK_Total_biaya_per_produk CHECK (Total_biaya_per_produk > 0),
    CONSTRAINT FK_Rincian_Penjualan_Penjualan FOREIGN KEY (No_transaksi) REFERENCES Penjualan (No_transaksi),
    CONSTRAINT FK_Rincian_Penjualan_Produk FOREIGN KEY (Produk_ID) REFERENCES Produk (Produk_ID),
    CONSTRAINT FK_Rincian_Penjualan_Diskon FOREIGN KEY (Diskon_produk_ID) REFERENCES Diskon_produk (Diskon_produk_ID),
    CONSTRAINT PK_Rincian_Penjualan PRIMARY KEY (Rincian_ID)
);


------table pengiriman-----
CREATE TABLE dbo.Pengiriman
(
    Pengiriman_ID      INT          NOT NULL,
    Tanggal_pengiriman DATE         NOT NULL,
    Tanggal_penerimaan DATE         NULL,
    Nama_Penerima      Nama         NULL,
    Alamat             VARCHAR(50) NOT NULL,
    Kelurahan          VARCHAR(50) NOT NULL,
    Kecamatan          VARCHAR(50) NOT NULL,
    Kabupaten_Kota     VARCHAR(50) NOT NULL,
    Provinsi           VARCHAR(50) NOT NULL,
    No_transaksi       INT          NOT NULL,
    Pegawai_ID         INT          NOT NULL,

    CONSTRAINT FK_Pengiriman_No_transaksi FOREIGN KEY (No_transaksi) REFERENCES Penjualan (No_transaksi),
    CONSTRAINT FK_Pengiriman_Pegawai FOREIGN KEY (Pegawai_ID) REFERENCES Pegawai (Pegawai_ID),
    CONSTRAINT PK_Pengiriman PRIMARY KEY (Pengiriman_ID)
);

--------------------------------INSERT DATA--------------------------------------
-- 2.1 Insert data dbo.Member table
INSERT INTO dbo.Member (Member_ID, No_KTP, Nama_Member, Jenis_kelamin, Alamat, Kelurahan, Kecamatan, Kabupaten_Kota,
                        Provinsi, tanggal_daftar_member, tanggal_kadaluarsa_member, No_Kontak, Jenis_Member_ID)
VALUES (1, '1234567890123456', 'John Doe', 'L', 'Jl. Contoh 123', 'Kelurahan A', 'Kecamatan X', 'Kota Y', 'Provinsi Z',
        '2023-01-01', '2024-01-01', '081234567890', 1),
       (2, '2345678901234567', 'Jane Doe', 'P', 'Jl. Sample 456', 'Kelurahan B', 'Kecamatan Y', 'Kota Z', 'Provinsi X',
        '2023-02-01', '2024-02-01', '081234567891', 2),
       (3, '3456789012345678', 'Alice Johnson', 'P', 'Jl. Demo 789', 'Kelurahan C', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2023-03-01', '2024-03-01', '081234567892', 1),
       (4, '4567890123456789', 'Bob Wilson', 'L', 'Jl. Test 101', 'Kelurahan D', 'Kecamatan X', 'Kota Y', 'Provinsi Z',
        '2023-04-01', '2024-04-01', '081234567893', 2),
       (5, '5678901234567890', 'Eva Brown', 'P', 'Jl. Example 111', 'Kelurahan E', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2023-05-01', '2024-05-01', '081234567894', 3),
       (6, '6789012345678901', 'Charlie Green', 'L', 'Jl. Showcase 121', 'Kelurahan F', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2023-06-01', '2024-06-01', '081234567895', 1),
       (7, '7890123456789012', 'Diana Taylor', 'P', 'Jl. Instance 131', 'Kelurahan G', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', '2023-07-01', '2024-07-01', '081234567896', 2),
       (8, '8901234567890123', 'Frank Rodriguez', 'L', 'Jl. Model 141', 'Kelurahan H', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2023-08-01', '2024-08-01', '081234567897', 3),
       (9, '9012345678901234', 'Grace Moore', 'P', 'Jl. Prototype 151', 'Kelurahan I', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2023-09-01', '2024-09-01', '081234567898', 1),
       (10, '0123456789012345', 'Harry Clark', 'L', 'Jl. Design 161', 'Kelurahan J', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', '2023-10-01', '2024-10-01', '081234567899', 2),
       (11, '1122334455667788', 'Ivy White', 'P', 'Jl. Pattern 171', 'Kelurahan K', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2023-11-01', '2024-11-01', '081234567810', 3),
       (12, '2233445566778899', 'Jack Black', 'L', 'Jl. Algorithm 181', 'Kelurahan L', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2023-12-01', '2024-12-01', '081234567811', 1),
       (13, '3344556677889900', 'Kelly Green', 'P', 'Jl. Database 191', 'Kelurahan M', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', '2024-01-01', '2025-01-01', '081234567812', 2),
       (14, '4455667788990011', 'Leo Brown', 'L', 'Jl. Interface 201', 'Kelurahan N', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2024-02-01', '2025-02-01', '081234567813', 3),
       (15, '5566778899001122', 'Mia Davis', 'P', 'Jl. Framework 211', 'Kelurahan O', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2024-03-01', '2025-03-01', '081234567814', 1),
       (16, '6677889900112233', 'Nathan White', 'L', 'Jl. Library 221', 'Kelurahan P', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', '2024-04-01', '2025-04-01', '081234567815', 2),
       (17, '7788990011223344', 'Olivia Taylor', 'P', 'Jl. Module 231', 'Kelurahan Q', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2024-05-01', '2025-05-01', '081234567816', 3),
       (18, '8899001122334455', 'Peter Harris', 'L', 'Jl. Package 241', 'Kelurahan R', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', '2024-06-01', '2025-06-01', '081234567817', 1),
       (19, '9900112233445566', 'Quincy Miller', 'P', 'Jl. Repository 251', 'Kelurahan S', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', '2024-07-01', '2025-07-01', '081234567818', 2),
       (20, '0011223344556677', 'Rita Foster', 'L', 'Jl. Version 261', 'Kelurahan T', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', '2024-08-01', '2025-08-01', '081234567819', 3);

SELECT *
FROM dbo.Member;

-- 2.2 Insert data dbo.Jenis_Member table
INSERT INTO dbo.Jenis_member (Jenis_Member_ID, Nama_jenis_member, Min_Trans, Deskripsi)
VALUES (1, 'Silver', '100000', 'Standard membership with basic benefits'),
       (2, 'Gold', '250000', 'Enhanced membership with additional perks'),
       (3, 'Platinum', '500000', 'Premium membership with exclusive privileges'),
       (4, 'Non-member', '0', 'No membership benefits');


SELECT *
FROM dbo.Jenis_member;

-- 2.3 Insert data dbo.Gerai table
INSERT INTO dbo.Gerai (Gerai_ID, Nama_cabang, Tanggal_pembukaan, Alamat, Kelurahan, Kecamatan, kabupaten_kota, Provinsi)
VALUES (1, 'Gerai A', '2023-01-01', 'Jl. Pusat 123', 'Kelurahan X', 'Kecamatan A', 'Kota P', 'Provinsi Q'),
       (2, 'Gerai B', '2023-02-01', 'Jl. Utama 456', 'Kelurahan Y', 'Kecamatan B', 'Kota Q', 'Provinsi R'),
       (3, 'Gerai C', '2023-03-01', 'Jl. Sentral 789', 'Kelurahan Z', 'Kecamatan C', 'Kota R', 'Provinsi S'),
       (4, 'Gerai D', '2023-04-01', 'Jl. Maju 101', 'Kelurahan A', 'Kecamatan D', 'Kota S', 'Provinsi T'),
       (5, 'Gerai E', '2023-05-01', 'Jl. Terdepan 111', 'Kelurahan B', 'Kecamatan E', 'Kota T', 'Provinsi U');


SELECT *
FROM dbo.Gerai;


---2.4 Insert data dbo.Pegawai table
INSERT INTO dbo.Pegawai (Pegawai_ID, Nama_pegawai, Jenis_kelamin, Tanggal_lahir, Tanggal_diterima, Alamat, Kelurahan,
                         Kecamatan, Kabupaten_Kota, Provinsi, Lulusan_pendidikan, Honor, Status_pernikahan, Jumlah_anak,
                         Jenis_pegawai, Jabatan_ID, Gerai_ID, Atasan_ID)
VALUES (1, 'John Doe', 'L', '1990-01-01', '2023-01-01', 'Jl. Karyawan 123', 'Kelurahan A', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', 'S1 Teknik Informatika', '5000000', 'Nikah', 2, '1', 1, 1, NULL),
       (2, 'Jane Doe', 'P', '1992-02-01', '2023-02-01', 'Jl. Staff 456', 'Kelurahan B', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', 'D3 Manajemen Bisnis', '6000000', 'Belum Nikah', 0, '2', 2, 2, NULL),
       (3, 'Alice Johnson', 'P', '1988-03-01', '2023-03-01', 'Jl. Supervisor 789', 'Kelurahan C', 'Kecamatan Z',
        'Kota X', 'Provinsi Y', 'S2 Ekonomi', '8000000', 'Nikah', 2, '3', 3, 3, 1),
       (4, 'Bob Wilson', 'L', '1985-04-01', '2023-04-01', 'Jl. Manager 101', 'Kelurahan D', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', 'S2 Manajemen', '10000000', 'Nikah', 1, '4', 3, 4, 2),
       (5, 'Eva Brown', 'P', '1987-05-01', '2023-05-01', 'Jl. Director 111', 'Kelurahan E', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', 'S3 Bisnis Internasional', '15000000', 'Belum Nikah', 0, '5', 2, 5, NULL),
       (6, 'Charlie Green', 'L', '1990-06-01', '2023-06-01', 'Jl. Head 121', 'Kelurahan F', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', 'S1 Hukum', '7000000', 'Nikah', 1, '1', 2, 1, NULL),
       (7, 'Diana Taylor', 'P', '1989-07-01', '2023-07-01', 'Jl. Chief 131', 'Kelurahan G', 'Kecamatan X', 'Kota Y',
        'Provinsi Z', 'S2 Psikologi', '9000000', 'Nikah', 2, '2', 2, 2, NULL),
       (8, 'Frank Rodriguez', 'L', '1986-08-01', '2023-08-01', 'Jl. VP 141', 'Kelurahan H', 'Kecamatan Y', 'Kota Z',
        'Provinsi X', 'S3 Ilmu Komputer', '12000000', 'Belum Nikah', 0, '3', 3, 3, 1),
       (9, 'Grace Moore', 'P', '1992-09-01', '2023-09-01', 'Jl. HR Manager 151', 'Kelurahan I', 'Kecamatan Z', 'Kota X',
        'Provinsi Y', 'S1 Hubungan Internasional', '7500000', 'Nikah', 2, '4', 2, 4, 2),
       (10, 'Harry Clark', 'L', '1988-10-01', '2023-10-01', 'Jl. IT Manager 161', 'Kelurahan J', 'Kecamatan X',
        'Kota Y', 'Provinsi Z', 'S2 Teknik Elektro', '11000000', 'Belum Nikah', 0, '5', 3, 5, NULL);

SELECT *
FROM dbo.Pegawai;

-- 2.5 Insert data dbo.Jabatan table
INSERT INTO dbo.Jabatan (Jabatan_ID, Nama_jabatan, Deskripsi)
VALUES (1, 'Kepala Cabang', 'Manajer puncak yang bertanggung jawab atas operasional cabang'),
       (2, 'Supervisor', 'Pengawas langsung terhadap kegiatan operasional di tingkat bawah'),
       (3, 'Pegawai', 'Anggota tim yang melaksanakan tugas operasional sehari-hari');

SELECT *
FROM dbo.Jabatan;


---2.6 Insert data dbo.Penjualan table
INSERT INTO dbo.Penjualan (No_transaksi, Tanggal_transaksi, Total_pembayaran, Jenis_pembayaran, Member_ID, Pegawai_ID)
VALUES (1, '2023-01-01', 500000, 1, 1, 1),
       (2, '2023-02-01', 750000, 2, 2, 2),
       (3, '2023-03-01', 1000000, 1, 3, 3),
       (4, '2023-04-01', 1200000, 2, 4, 4),
       (5, '2023-05-01', 800000, 1, 5, 5),
       (6, '2023-06-01', 600000, 2, 6, 6),
       (7, '2023-07-01', 900000, 1, 7, 7),
       (8, '2023-08-01', 1100000, 2, 8, 8),
       (9, '2023-09-01', 950000, 1, 9, 9),
       (10, '2023-10-01', 700000, 2, 10, 10);


SELECT *
FROM dbo.Penjualan;

--- 2.7 Insert data dbo.Pengiriman table
INSERT INTO dbo.Pengiriman (Pengiriman_ID, Tanggal_pengiriman, Tanggal_penerimaan, Nama_Penerima, Alamat, Kelurahan,
                            Kecamatan, Kabupaten_Kota, Provinsi, No_transaksi, Pegawai_ID)
VALUES (1, '2023-01-05', '2023-01-10', 'John Receiver', 'Jl. Penerimaan 123', 'Kelurahan P', 'Kecamatan A', 'Kota P',
        'Provinsi Q', 1, 1),
       (2, '2023-02-08', '2023-02-12', 'Jane Receiver', 'Jl. Penerimaan 456', 'Kelurahan Q', 'Kecamatan B', 'Kota Q',
        'Provinsi R', 2, 2),
       (3, '2023-03-15', '2023-03-20', 'Alice Receiver', 'Jl. Penerimaan 789', 'Kelurahan R', 'Kecamatan C', 'Kota R',
        'Provinsi S', 3, 3);

SELECT *
FROM dbo.Pengiriman;

-- 2.8 Insert data dbo.Rincian_Penjualan
INSERT INTO dbo.Rincian_Penjualan (Rincian_ID, No_transaksi, Produk_ID, Harga_satuan, Kuantitas_penjualan,
                                   Diskon_produk_ID, Nominal_diskon)
VALUES (1, 1, 1, 50000, 2, 1, 10000),
       (2, 1, 2, 75000, 3, 2, 15000),
       (3, 2, 3, 100000, 1, 3, 20000),
       (4, 2, 4, 120000, 2, 1, 25000),
       (5, 3, 5, 80000, 3, 2, 30000),
       (6, 3, 6, 60000, 1, 3, 10000),
       (7, 4, 7, 90000, 2, 4, 20000),
       (8, 4, 8, 110000, 3, 5, 25000),
       (9, 5, 9, 95000, 1, 3, 30000),
       (10, 5, 10, 70000, 1, 5, 15000);


SELECT *
FROM dbo.Rincian_Penjualan;

---2.9 Insert data dbo.Diskon table
INSERT INTO dbo.Diskon (Diskon_ID, Persen_Diskon, Tanggal_awal_berlaku, Tanggal_akhir_berlaku, MinQty, Deskripsi)
VALUES (1, 10.00, '2023-01-01', '2023-01-31', 3, 'Diskon 10% untuk pembelian minimal 3 produk'),
       (2, 15.00, '2023-02-01', '2023-02-28', 5, 'Diskon 15% untuk pembelian minimal 5 produk'),
       (3, 20.00, '2023-03-01', '2023-03-31', 2, 'Diskon 20% untuk pembelian minimal 2 produk');


SELECT *
FROM dbo.Diskon;

---3.0 Insert data dbo.Produk table
INSERT INTO dbo.Produk (Produk_ID, Nama_produk, Jenis_produk, tanggal_kadaluarsa, berat, satuan_berat, sumber_produk,
                        harga_satuan, Supplier_ID)
VALUES (1, 'Produk A', 'Makanan', '2023-01-10', 0.5, 'Kg', 'Pabrik A', 50000, 1),
       (2, 'Produk B', 'Minuman', '2023-02-15', 0.75, 'L', 'Pabrik B', 75000, 2),
       (3, 'Produk C', 'Elektronik', '2023-03-20', 2.0, 'Kg', 'Pabrik C', 120000, 2),
       (4, 'Produk D', 'Fashion', '2023-04-25', 0.3, 'Kg', 'Pabrik D', 80000, 1),
       (5, 'Produk E', 'Kesehatan', '2023-05-30', 1.5, 'L', 'Pabrik E', 95000, 2),
       (6, 'Produk F', 'Makanan', '2023-06-05', 0.8, 'Kg', 'Pabrik A', 60000, 1),
       (7, 'Produk G', 'Minuman', '2023-07-10', 1.0, 'L', 'Pabrik B', 90000, 2),
       (8, 'Produk H', 'Elektronik', '2023-08-15', 2.5, 'Kg', 'Pabrik C', 110000, 1),
       (9, 'Produk I', 'Fashion', '2023-09-20', 0.4, 'Kg', 'Pabrik D', 70000, 2),
       (10, 'Produk J', 'Kesehatan', '2023-10-25', 1.2, 'L', 'Pabrik E', 85000, 2);


SELECT *
FROM dbo.Produk;


---3.1 Insert data dbo.Diskon_produk table
use PBD
GO
INSERT INTO dbo.Diskon_produk (Diskon_produk_ID, Diskon_ID, produk_ID)
VALUES (1, 1, 1),
       (2, 2, 2),
       (3, 3, 3),
       (4, 2, 4),
       (5, 1, 5);


SELECT *
FROM dbo.Diskon_produk;


---3.2 Insert data dbo.supplier table
INSERT INTO dbo.Supplier (Supplier_ID, Nama_Supplier, Alamat, Kelurahan, Kecamatan, Kabupaten_Kota, Provinsi, No_Kontak)
VALUES (1, 'Supplier A', 'Jl. Raya 123', 'Kelurahan X', 'Kecamatan A', 'Kota P', 'Provinsi Q', '08123456789'),
       (2, 'Supplier B', 'Jl. Utama 456', 'Kelurahan Y', 'Kecamatan B', 'Kota Q', 'Provinsi R', '08567890123');

SELECT *
FROM dbo.Supplier;


