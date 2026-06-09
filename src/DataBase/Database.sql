-- ============================================================
-- RESTAURANT DATABASE - PostgreSQL Version
-- Converted from Oracle SQL
-- ============================================================

-- Tao bang NguoiDung
CREATE TABLE NguoiDung (
                           ID_ND       INTEGER,
                           Email       VARCHAR(50),
                           Matkhau     VARCHAR(20),
                           VerifyCode  VARCHAR(10) DEFAULT NULL,
                           Trangthai   VARCHAR(10) DEFAULT '',
                           Vaitro      VARCHAR(20)
);

-- Them rang buoc
ALTER TABLE NguoiDung
    ADD CONSTRAINT ND_Email_NNULL    CHECK (Email IS NOT NULL),
    ADD CONSTRAINT ND_Matkhau_NNULL  CHECK (Matkhau IS NOT NULL),
    ADD CONSTRAINT ND_Vaitro_Ten     CHECK (Vaitro IN ('Khach Hang','Nhan Vien','Nhan Vien Kho','Quan Ly'));

-- Them khoa chinh
ALTER TABLE NguoiDung
    ADD CONSTRAINT NguoiDung_PK PRIMARY KEY (ID_ND);


-- Tao bang NhanVien
CREATE TABLE NhanVien (
                          ID_NV       INTEGER,
                          TenNV       VARCHAR(50),
                          NgayVL      DATE,
                          SDT         VARCHAR(50),
                          Chucvu      VARCHAR(50),
                          ID_ND       INTEGER DEFAULT NULL,
                          ID_NQL      INTEGER,
                          Tinhtrang   VARCHAR(20)
);

-- Them Check Constraint
ALTER TABLE NhanVien
    ADD CONSTRAINT NV_TenNV_NNULL      CHECK (TenNV IS NOT NULL),
    ADD CONSTRAINT NV_SDT_NNULL        CHECK (SDT IS NOT NULL),
    ADD CONSTRAINT NV_NgayVL_NNULL     CHECK (NgayVL IS NOT NULL),
    ADD CONSTRAINT NV_Chucvu_Thuoc     CHECK (Chucvu IN ('Phuc vu','Tiep tan','Thu ngan','Bep','Kho','Quan ly')),
    ADD CONSTRAINT NV_Tinhtrang_Thuoc  CHECK (Tinhtrang IN ('Dang lam viec','Da nghi viec'));

-- Them khoa chinh
ALTER TABLE NhanVien
    ADD CONSTRAINT NV_PK PRIMARY KEY (ID_NV);

-- Them khoa ngoai
ALTER TABLE NhanVien
    ADD CONSTRAINT NV_fk_idND  FOREIGN KEY (ID_ND)  REFERENCES NguoiDung(ID_ND),
    ADD CONSTRAINT NV_fk_idNQL FOREIGN KEY (ID_NQL) REFERENCES NhanVien(ID_NV);


-- Tao bang KhachHang
CREATE TABLE KhachHang (
                           ID_KH           INTEGER,
                           TenKH           VARCHAR(50),
                           Ngaythamgia     DATE,
                           Doanhso         NUMERIC(10,0) DEFAULT 0,
                           Diemtichluy     NUMERIC(5,0)  DEFAULT 0,
                           ID_ND           INTEGER
);

-- Them Check Constraint
ALTER TABLE KhachHang
    ADD CONSTRAINT KH_TenKH_NNULL       CHECK (TenKH IS NOT NULL),
    ADD CONSTRAINT KH_Ngaythamgia_NNULL CHECK (Ngaythamgia IS NOT NULL),
    ADD CONSTRAINT KH_Doanhso_NNULL     CHECK (Doanhso IS NOT NULL),
    ADD CONSTRAINT KH_Diemtichluy_NNULL CHECK (Diemtichluy IS NOT NULL),
    ADD CONSTRAINT KH_IDND_NNULL        CHECK (ID_ND IS NOT NULL);

-- Them khoa chinh
ALTER TABLE KhachHang
    ADD CONSTRAINT KhachHang_PK PRIMARY KEY (ID_KH);

-- Them khoa ngoai
ALTER TABLE KhachHang
    ADD CONSTRAINT KH_fk_idND FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND);


-- Tao bang MonAn
CREATE TABLE MonAn (
                       ID_MonAn    INTEGER,
                       TenMon      VARCHAR(50),
                       DonGia      NUMERIC(8,0),
                       Loai        VARCHAR(50),
                       TrangThai   VARCHAR(30)
);

-- Them Check Constraint
ALTER TABLE MonAn
    ADD CONSTRAINT MA_TenMon_NNULL   CHECK (TenMon IS NOT NULL),
    ADD CONSTRAINT MA_DonGia_NNULL   CHECK (DonGia IS NOT NULL),
    ADD CONSTRAINT MA_Loai_Ten       CHECK (Loai IN ('Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                                                     'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces')),
    ADD CONSTRAINT MA_TrangThai_Thuoc CHECK (TrangThai IN ('Dang kinh doanh','Ngung kinh doanh'));

-- Them khoa chinh
ALTER TABLE MonAn
    ADD CONSTRAINT MonAn_PK PRIMARY KEY (ID_MonAn);


-- Tao bang Ban
CREATE TABLE Ban (
                     ID_Ban      INTEGER,
                     TenBan      VARCHAR(50),
                     Vitri       VARCHAR(50),
                     Trangthai   VARCHAR(50)
);

-- Them Check Constraint
ALTER TABLE Ban
    ADD CONSTRAINT Ban_TenBan_NNULL    CHECK (TenBan IS NOT NULL),
    ADD CONSTRAINT Ban_Vitri_NNULL     CHECK (Vitri IS NOT NULL),
    ADD CONSTRAINT Ban_Trangthai_Ten   CHECK (Trangthai IN ('Con trong','Dang dung bua','Da dat truoc'));

-- Them khoa chinh
ALTER TABLE Ban
    ADD CONSTRAINT Ban_PK PRIMARY KEY (ID_Ban);


-- Tao bang Voucher
CREATE TABLE Voucher (
                         Code_Voucher    VARCHAR(10),
                         Mota            VARCHAR(50),
                         Phantram        NUMERIC(3,0),
                         LoaiMA          VARCHAR(50),
                         SoLuong         NUMERIC(3,0),
                         Diem            NUMERIC(8,0)
);

-- Them Check Constraint
ALTER TABLE Voucher
    ADD CONSTRAINT V_Code_NNULL      CHECK (Code_Voucher IS NOT NULL),
    ADD CONSTRAINT V_Mota_NNULL      CHECK (Mota IS NOT NULL),
    ADD CONSTRAINT V_Phantram_NNULL  CHECK (Phantram > 0 AND Phantram <= 100),
    ADD CONSTRAINT V_LoaiMA_Thuoc    CHECK (LoaiMA IN ('All','Aries','Taurus','Gemini','Cancer','Leo','Virgo',
                                                       'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces'));

-- Them khoa chinh
ALTER TABLE Voucher
    ADD CONSTRAINT Voucher_PK PRIMARY KEY (Code_Voucher);


-- Tao bang HoaDon
CREATE TABLE HoaDon (
                        ID_HoaDon       INTEGER,
                        ID_KH           INTEGER,
                        ID_Ban          INTEGER,
                        NgayHD          DATE,
                        TienMonAn       NUMERIC(8,0)  DEFAULT 0,
                        Code_Voucher    VARCHAR(10),
                        TienGiam        NUMERIC(8,0)  DEFAULT 0,
                        Tongtien        NUMERIC(10,0) DEFAULT 0,
                        Trangthai       VARCHAR(50)
);

-- Them Check Constraint
ALTER TABLE HoaDon
    ADD CONSTRAINT HD_NgayHD_NNULL  CHECK (NgayHD IS NOT NULL),
    ADD CONSTRAINT HD_TrangThai     CHECK (Trangthai IN ('Chua thanh toan','Da thanh toan'));

-- Them khoa chinh
ALTER TABLE HoaDon
    ADD CONSTRAINT HD_PK PRIMARY KEY (ID_HoaDon);

-- Them khoa ngoai
ALTER TABLE HoaDon
    ADD CONSTRAINT HD_fk_idKH  FOREIGN KEY (ID_KH)  REFERENCES KhachHang(ID_KH),
    ADD CONSTRAINT HD_fk_idBan FOREIGN KEY (ID_Ban)  REFERENCES Ban(ID_Ban);


-- Tao bang CTHD
CREATE TABLE CTHD (
                      ID_HoaDon   INTEGER,
                      ID_MonAn    INTEGER,
                      SoLuong     NUMERIC(3,0),
                      Thanhtien   NUMERIC(10,0)
);

-- Them Check Constraint
ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_SoLuong_NNULL CHECK (SoLuong IS NOT NULL);

-- Them khoa chinh
ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_PK PRIMARY KEY (ID_HoaDon, ID_MonAn);

-- Them khoa ngoai
ALTER TABLE CTHD
    ADD CONSTRAINT CTHD_fk_idHD     FOREIGN KEY (ID_HoaDon) REFERENCES HoaDon(ID_HoaDon),
    ADD CONSTRAINT CTHD_fk_idMonAn  FOREIGN KEY (ID_MonAn)  REFERENCES MonAn(ID_MonAn);


-- Tao bang NguyenLieu
CREATE TABLE NguyenLieu (
                            ID_NL       INTEGER,
                            TenNL       VARCHAR(50),
                            Dongia      NUMERIC(8,0),
                            Donvitinh   VARCHAR(50)
);

-- Them Check Constraint
ALTER TABLE NguyenLieu
    ADD CONSTRAINT NL_TenNL_NNULL  CHECK (TenNL IS NOT NULL),
    ADD CONSTRAINT NL_Dongia_NNULL CHECK (Dongia IS NOT NULL),
    ADD CONSTRAINT NL_DVT_Thuoc    CHECK (Donvitinh IN ('g','kg','ml','l'));

-- Them khoa chinh
ALTER TABLE NguyenLieu
    ADD CONSTRAINT NL_PK PRIMARY KEY (ID_NL);


-- Tao bang Kho
CREATE TABLE Kho (
                     ID_NL   INTEGER,
                     SLTon   NUMERIC(3,0) DEFAULT 0
);

-- Them khoa chinh
ALTER TABLE Kho
    ADD CONSTRAINT Kho_pk PRIMARY KEY (ID_NL);

-- Them khoa ngoai
ALTER TABLE Kho
    ADD CONSTRAINT Kho_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);


-- Tao bang PhieuNK
CREATE TABLE PhieuNK (
                         ID_NK       INTEGER,
                         ID_NV       INTEGER,
                         NgayNK      DATE,
                         Tongtien    NUMERIC(10,0) DEFAULT 0
);

-- Them Check Constraint
ALTER TABLE PhieuNK
    ADD CONSTRAINT PNK_NgayNK_NNULL CHECK (NgayNK IS NOT NULL);

-- Them khoa chinh
ALTER TABLE PhieuNK
    ADD CONSTRAINT PNK_PK PRIMARY KEY (ID_NK);

-- Them khoa ngoai
ALTER TABLE PhieuNK
    ADD CONSTRAINT PNK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV);


-- Tao bang CTNK
CREATE TABLE CTNK (
                      ID_NK       INTEGER,
                      ID_NL       INTEGER,
                      SoLuong     NUMERIC(3,0),
                      Thanhtien   NUMERIC(10,0)
);

-- Them Check Constraint
ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_SL_NNULL CHECK (SoLuong IS NOT NULL);

-- Them khoa chinh
ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_PK PRIMARY KEY (ID_NK, ID_NL);

-- Them khoa ngoai
ALTER TABLE CTNK
    ADD CONSTRAINT CTNK_fk_idNK FOREIGN KEY (ID_NK) REFERENCES PhieuNK(ID_NK),
    ADD CONSTRAINT CTNK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);


-- Tao bang PhieuXK
CREATE TABLE PhieuXK (
                         ID_XK   INTEGER,
                         ID_NV   INTEGER,
                         NgayXK  DATE
);

-- Them Check Constraint
ALTER TABLE PhieuXK
    ADD CONSTRAINT PXK_NgayXK_NNULL CHECK (NgayXK IS NOT NULL);

-- Them khoa chinh
ALTER TABLE PhieuXK
    ADD CONSTRAINT PXK_PK PRIMARY KEY (ID_XK);

-- Them khoa ngoai
ALTER TABLE PhieuXK
    ADD CONSTRAINT PXK_fk_idNV FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV);


-- Tao bang CTXK
CREATE TABLE CTXK (
                      ID_XK   INTEGER,
                      ID_NL   INTEGER,
                      SoLuong NUMERIC(3,0)
);

-- Them Check Constraint
ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_SL_NNULL CHECK (SoLuong IS NOT NULL);

-- Them khoa chinh
ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_PK PRIMARY KEY (ID_XK, ID_NL);

-- Them khoa ngoai
ALTER TABLE CTXK
    ADD CONSTRAINT CTXK_fk_idXK FOREIGN KEY (ID_XK) REFERENCES PhieuXK(ID_XK),
    ADD CONSTRAINT CTXK_fk_idNL FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL);


-- ============================================================
-- FUNCTIONS (thay cho Oracle FUNCTION)
-- ============================================================

-- Function tinh tien giam
CREATE OR REPLACE FUNCTION Tinhtiengiam(p_Tongtien NUMERIC, p_Code VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
v_Phantram NUMERIC;
BEGIN
SELECT Phantram INTO v_Phantram
FROM Voucher
WHERE Code_Voucher = p_Code;

RETURN ROUND(p_Tongtien * v_Phantram / 100);
END;
$$ LANGUAGE plpgsql;

-- Function tinh doanh thu hoa don theo ngay
CREATE OR REPLACE FUNCTION DoanhThuHD_theoNgay(ngHD DATE)
RETURNS NUMERIC AS $$
DECLARE
v_Doanhthu NUMERIC;
BEGIN
SELECT COALESCE(SUM(Tongtien), 0) INTO v_Doanhthu
FROM HoaDon
WHERE NgayHD = ngHD;

RETURN v_Doanhthu;
END;
$$ LANGUAGE plpgsql;

-- Function tinh chi phi nhap kho theo ngay
CREATE OR REPLACE FUNCTION ChiPhiNK_theoNgay(ngNK DATE)
RETURNS NUMERIC AS $$
DECLARE
v_Chiphi NUMERIC;
BEGIN
SELECT COALESCE(SUM(Tongtien), 0) INTO v_Chiphi
FROM PhieuNK
WHERE NgayNK = ngNK;

RETURN v_Chiphi;
END;
$$ LANGUAGE plpgsql;

-- Function tinh doanh so trung binh cua TOP x KhachHang
CREATE OR REPLACE FUNCTION DoanhsoTB_TOPxKH(x INT)
RETURNS NUMERIC AS $$
DECLARE
v_avg NUMERIC;
BEGIN
SELECT AVG(Doanhso) INTO v_avg
FROM (
         SELECT Doanhso
         FROM KhachHang
         ORDER BY Doanhso DESC
             LIMIT x
     ) sub;

RETURN v_avg;
END;
$$ LANGUAGE plpgsql;

-- Function tinh so luong KhachHang moi trong thang/nam co it nhat 1 hoa don tren x vnd
CREATE OR REPLACE FUNCTION SL_KH_Moi(thang INTEGER, nam INTEGER, trigiaHD NUMERIC)
RETURNS INTEGER AS $$
DECLARE
v_count INTEGER;
BEGIN
SELECT COUNT(ID_KH) INTO v_count
FROM KhachHang
WHERE EXTRACT(MONTH FROM Ngaythamgia) = thang
  AND EXTRACT(YEAR  FROM Ngaythamgia) = nam
  AND EXISTS (
    SELECT 1
    FROM HoaDon
    WHERE HoaDon.ID_KH = KhachHang.ID_KH
      AND Tongtien > trigiaHD
);

RETURN v_count;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- STORED PROCEDURES (dung PROCEDURE trong PostgreSQL 11+)
-- ============================================================

-- Procedure giam So Luong Voucher di 1
CREATE OR REPLACE PROCEDURE Voucher_GiamSL(p_code VARCHAR)
LANGUAGE plpgsql AS $$
DECLARE
v_count INTEGER;
BEGIN
SELECT COUNT(*) INTO v_count FROM Voucher WHERE Code_Voucher = p_code;
IF v_count > 0 THEN
UPDATE Voucher SET SoLuong = SoLuong - 1 WHERE Code_Voucher = p_code;
ELSE
        RAISE EXCEPTION 'Voucher khong ton tai';
END IF;
END;
$$;

-- Procedure giam Diem tich luy cua KhachHang khi doi Voucher
CREATE OR REPLACE PROCEDURE KH_TruDTL(p_ID INTEGER, p_diemdoi NUMERIC)
LANGUAGE plpgsql AS $$
DECLARE
v_count INTEGER;
BEGIN
SELECT COUNT(*) INTO v_count FROM KhachHang WHERE ID_KH = p_ID;
IF v_count > 0 THEN
UPDATE KhachHang SET Diemtichluy = Diemtichluy - p_diemdoi WHERE ID_KH = p_ID;
ELSE
        RAISE EXCEPTION 'Khach hang khong ton tai';
END IF;
END;
$$;

-- Procedure them KhachHang moi
CREATE OR REPLACE PROCEDURE KH_ThemKH(
    p_tenKH     VARCHAR,
    p_NgayTG    DATE,
    p_ID_ND     INTEGER
)
LANGUAGE plpgsql AS $$
DECLARE
v_ID_KH INTEGER;
BEGIN
SELECT COALESCE(MAX(ID_KH), 99) + 1 INTO v_ID_KH FROM KhachHang;

INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND)
VALUES (v_ID_KH, p_tenKH, p_NgayTG, p_ID_ND);
EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Thong tin khong hop le: %', SQLERRM;
END;
$$;

-- Procedure them NhanVien moi
CREATE OR REPLACE PROCEDURE NV_ThemNV(
    p_tenNV     VARCHAR,
    p_NgayVL    DATE,
    p_SDT       VARCHAR,
    p_Chucvu    VARCHAR,
    p_ID_NQL    INTEGER,
    p_Tinhtrang VARCHAR
)
LANGUAGE plpgsql AS $$
DECLARE
v_ID_NV INTEGER;
BEGIN
SELECT COALESCE(MAX(ID_NV), 99) + 1 INTO v_ID_NV FROM NhanVien;

INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang)
VALUES (v_ID_NV, p_tenNV, p_NgayVL, p_SDT, p_Chucvu, p_ID_NQL, p_Tinhtrang);
EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Thong tin khong hop le: %', SQLERRM;
END;
$$;

-- Procedure xoa NhanVien
CREATE OR REPLACE PROCEDURE NV_XoaNV(p_idNV INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
v_count  INTEGER;
    v_idNQL  INTEGER;
BEGIN
SELECT COUNT(ID_NV), MAX(ID_NQL) INTO v_count, v_idNQL
FROM NhanVien WHERE ID_NV = p_idNV;

IF v_count > 0 THEN
        IF p_idNV = v_idNQL THEN
            RAISE EXCEPTION 'Khong the xoa QUAN LY';
ELSE
DELETE FROM CTNK WHERE ID_NK IN (SELECT ID_NK FROM PhieuNK WHERE ID_NV = p_idNV);
DELETE FROM CTXK WHERE ID_XK IN (SELECT ID_XK FROM PhieuXK WHERE ID_NV = p_idNV);
DELETE FROM PhieuNK WHERE ID_NV = p_idNV;
DELETE FROM PhieuXK WHERE ID_NV = p_idNV;
DELETE FROM NhanVien  WHERE ID_NV = p_idNV;
END IF;
ELSE
        RAISE EXCEPTION 'Nhan vien khong ton tai';
END IF;
END;
$$;

-- Procedure xoa KhachHang
CREATE OR REPLACE PROCEDURE KH_XoaKH(p_idKH INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
v_count INTEGER;
BEGIN
SELECT COUNT(*) INTO v_count FROM KhachHang WHERE ID_KH = p_idKH;
IF v_count > 0 THEN
DELETE FROM CTHD   WHERE ID_HoaDon IN (SELECT ID_HoaDon FROM HoaDon WHERE ID_KH = p_idKH);
DELETE FROM HoaDon WHERE ID_KH = p_idKH;
DELETE FROM KhachHang WHERE ID_KH = p_idKH;
ELSE
        RAISE EXCEPTION 'Khach hang khong ton tai';
END IF;
END;
$$;

-- Procedure xem thong tin KhachHang
CREATE OR REPLACE PROCEDURE KH_XemTT(p_idKH INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT TenKH, Ngaythamgia, Doanhso, Diemtichluy, ID_ND
FROM KhachHang WHERE ID_KH = p_idKH
    LOOP
        RAISE NOTICE 'Ma khach hang: %',  p_idKH;
RAISE NOTICE 'Ten khach hang: %', cur.TenKH;
        RAISE NOTICE 'Ngay tham gia: %',  TO_CHAR(cur.Ngaythamgia,'DD-MM-YYYY');
        RAISE NOTICE 'Doanh so: %',        cur.Doanhso;
        RAISE NOTICE 'Diem tich luy: %',   cur.Diemtichluy;
        RAISE NOTICE 'Ma nguoi dung: %',   cur.ID_ND;
END LOOP;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Khach hang khong ton tai';
END IF;
END;
$$;

-- Procedure xem thong tin NhanVien
CREATE OR REPLACE PROCEDURE NV_XemTT(p_idNV INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT TenNV, NgayVL, SDT, Chucvu, ID_NQL
FROM NhanVien WHERE ID_NV = p_idNV
    LOOP
        RAISE NOTICE 'Ma nhan vien: %',    p_idNV;
RAISE NOTICE 'Ten nhan vien: %',   cur.TenNV;
        RAISE NOTICE 'Ngay vao lam: %',    TO_CHAR(cur.NgayVL,'DD-MM-YYYY');
        RAISE NOTICE 'Chuc vu: %',          cur.Chucvu;
        RAISE NOTICE 'Ma nguoi quan ly: %', cur.ID_NQL;
END LOOP;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Nhan vien khong ton tai';
END IF;
END;
$$;

-- Procedure liet ke danh sach HoaDon tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_HoaDon_tuAdenB(p_fromA DATE, p_toB DATE)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Tongtien, Trangthai
FROM HoaDon
WHERE NgayHD BETWEEN p_fromA AND (p_toB + INTERVAL '1 day')
    LOOP
        RAISE NOTICE 'Ma hoa don: %',  cur.ID_HoaDon;
RAISE NOTICE 'Ma khach hang: %', cur.ID_KH;
        RAISE NOTICE 'Ma ban: %',         cur.ID_Ban;
        RAISE NOTICE 'Ngay hoa don: %',   TO_CHAR(cur.NgayHD,'DD-MM-YYYY');
        RAISE NOTICE 'Tien mon an: %',    cur.TienMonAn;
        RAISE NOTICE 'Tien giam: %',      cur.TienGiam;
        RAISE NOTICE 'Tong tien: %',      cur.Tongtien;
        RAISE NOTICE 'Trang thai: %',     cur.Trangthai;
END LOOP;
END;
$$;

-- Procedure liet ke danh sach PhieuNK tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_PhieuNK_tuAdenB(p_fromA DATE, p_toB DATE)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT ID_NK, ID_NV, NgayNK, Tongtien
FROM PhieuNK
WHERE NgayNK BETWEEN p_fromA AND (p_toB + INTERVAL '1 day')
    LOOP
        RAISE NOTICE 'Ma nhap kho: %',   cur.ID_NK;
RAISE NOTICE 'Ma nhan vien: %',  cur.ID_NV;
        RAISE NOTICE 'Ngay nhap kho: %', TO_CHAR(cur.NgayNK,'DD-MM-YYYY');
        RAISE NOTICE 'Tong tien: %',     cur.Tongtien;
END LOOP;
END;
$$;

-- Procedure liet ke danh sach PhieuXK tu ngay A den ngay B
CREATE OR REPLACE PROCEDURE DS_PhieuXK_tuAdenB(p_fromA DATE, p_toB DATE)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT ID_XK, ID_NV, NgayXK
FROM PhieuXK
WHERE NgayXK BETWEEN p_fromA AND (p_toB + INTERVAL '1 day')
    LOOP
        RAISE NOTICE 'Ma xuat kho: %',   cur.ID_XK;
RAISE NOTICE 'Ma nhan vien: %',  cur.ID_NV;
        RAISE NOTICE 'Ngay xuat kho: %', TO_CHAR(cur.NgayXK,'DD-MM-YYYY');
END LOOP;
END;
$$;

-- Procedure xem chi tiet hoa don
CREATE OR REPLACE PROCEDURE HD_XemCTHD(p_idHD INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
cur RECORD;
BEGIN
FOR cur IN
SELECT ID_MonAn, SoLuong, Thanhtien
FROM CTHD WHERE ID_HoaDon = p_idHD
    LOOP
        RAISE NOTICE 'Ma mon an: %',  cur.ID_MonAn;
RAISE NOTICE 'So luong: %',   cur.SoLuong;
        RAISE NOTICE 'Thanh tien: %', cur.Thanhtien;
END LOOP;
END;
$$;


-- ============================================================
-- TRIGGERS
-- ============================================================

-- Trigger: KhachHang chi duoc co toi da 1 hoa don 'Chua thanh toan'
CREATE OR REPLACE FUNCTION fn_Tg_SLHD_CTT()
RETURNS TRIGGER AS $$
DECLARE
v_count INTEGER;
BEGIN
SELECT COUNT(*) INTO v_count
FROM HoaDon
WHERE ID_KH = NEW.ID_KH AND Trangthai = 'Chua thanh toan';

-- Khi INSERT: ban ghi moi chua ton tai, count > 0 la co 1 roi
-- Khi UPDATE: ban ghi hien tai van duoc tinh, nen count > 1 moi vi pham
IF (TG_OP = 'INSERT' AND v_count >= 1) OR
       (TG_OP = 'UPDATE' AND v_count > 1) THEN
        RAISE EXCEPTION 'Moi khach hang chi duoc co toi da mot hoa don co trang thai chua thanh toan';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_SLHD_CTT
    BEFORE INSERT OR UPDATE OF ID_KH, Trangthai ON HoaDon
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_SLHD_CTT();


-- Trigger: Thanh tien o CTHD = SoLuong x DonGia
CREATE OR REPLACE FUNCTION fn_Tg_CTHD_Thanhtien()
RETURNS TRIGGER AS $$
DECLARE
gia NUMERIC;
BEGIN
SELECT DonGia INTO gia FROM MonAn WHERE ID_MonAn = NEW.ID_MonAn;
NEW.ThanhTien := NEW.SoLuong * gia;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_CTHD_Thanhtien
    BEFORE INSERT OR UPDATE OF SoLuong ON CTHD
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_CTHD_Thanhtien();


-- Trigger: TienMonAn o HoaDon = tong ThanhTien o CTHD
CREATE OR REPLACE FUNCTION fn_Tg_HD_TienMonAn()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
UPDATE HoaDon SET TienMonAn = TienMonAn + NEW.ThanhTien WHERE ID_HoaDon = NEW.ID_HoaDon;
ELSIF TG_OP = 'UPDATE' THEN
UPDATE HoaDon SET TienMonAn = TienMonAn + NEW.ThanhTien - OLD.ThanhTien WHERE ID_HoaDon = NEW.ID_HoaDon;
ELSIF TG_OP = 'DELETE' THEN
UPDATE HoaDon SET TienMonAn = TienMonAn - OLD.ThanhTien WHERE ID_HoaDon = OLD.ID_HoaDon;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_HD_TienMonAn
    AFTER INSERT OR UPDATE OR DELETE ON CTHD
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_HD_TienMonAn();


-- Trigger: TienGiam o HoaDon tinh theo Voucher
CREATE OR REPLACE FUNCTION fn_Tg_HD_TienGiam()
RETURNS TRIGGER AS $$
DECLARE
v_code   HoaDon.Code_Voucher%TYPE;
    v_loaiMA Voucher.LoaiMA%TYPE;
    MA_Loai  MonAn.Loai%TYPE;
BEGIN
    v_code := NULL;

    IF TG_OP IN ('INSERT','UPDATE') THEN
SELECT hd.Code_Voucher, v.LoaiMA
INTO v_code, v_loaiMA
FROM HoaDon hd
         LEFT JOIN Voucher v ON v.Code_Voucher = hd.Code_Voucher
WHERE hd.ID_HoaDon = NEW.ID_HoaDon;

SELECT Loai INTO MA_Loai FROM MonAn WHERE ID_MonAn = NEW.ID_MonAn;
ELSIF TG_OP = 'DELETE' THEN
SELECT hd.Code_Voucher, v.LoaiMA
INTO v_code, v_loaiMA
FROM HoaDon hd
         LEFT JOIN Voucher v ON v.Code_Voucher = hd.Code_Voucher
WHERE hd.ID_HoaDon = OLD.ID_HoaDon;

SELECT Loai INTO MA_Loai FROM MonAn WHERE ID_MonAn = OLD.ID_MonAn;
END IF;

    IF v_code IS NOT NULL THEN
        IF v_loaiMA = 'All' OR v_loaiMA = MA_Loai THEN
            IF TG_OP = 'INSERT' THEN
UPDATE HoaDon SET TienGiam = TienGiam + Tinhtiengiam(NEW.ThanhTien, v_code)
WHERE ID_HoaDon = NEW.ID_HoaDon;
ELSIF TG_OP = 'UPDATE' THEN
UPDATE HoaDon SET TienGiam = TienGiam + Tinhtiengiam(NEW.ThanhTien, v_code)
    - Tinhtiengiam(OLD.ThanhTien, v_code)
WHERE ID_HoaDon = NEW.ID_HoaDon;
ELSIF TG_OP = 'DELETE' THEN
UPDATE HoaDon SET TienGiam = TienGiam - Tinhtiengiam(OLD.ThanhTien, v_code)
WHERE ID_HoaDon = OLD.ID_HoaDon;
END IF;
END IF;
END IF;

RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_HD_TienGiam
    AFTER INSERT OR UPDATE OR DELETE ON CTHD
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_HD_TienGiam();


-- Trigger: Tongtien o HoaDon = TienMonAn - TienGiam
CREATE OR REPLACE FUNCTION fn_Tg_HD_Tongtien()
RETURNS TRIGGER AS $$
BEGIN
UPDATE HoaDon SET Tongtien = TienMonAn - TienGiam;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_HD_Tongtien
    AFTER INSERT OR UPDATE OF TienMonAn, TienGiam ON HoaDon
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_HD_Tongtien();


-- Trigger: Cap nhat Code_Voucher o HoaDon -> tinh TienGiam, tru DTL cua KH
CREATE OR REPLACE FUNCTION fn_Tg_HD_DoiVoucher()
RETURNS TRIGGER AS $$
DECLARE
TongtienLoaiMonAnduocgiam NUMERIC;
    v_Diemdoi  NUMERIC;
    v_Phantram NUMERIC;
    v_LoaiMA   Voucher.LoaiMA%TYPE;
BEGIN
    IF NEW.Code_Voucher IS NOT NULL THEN
SELECT Diem, Phantram, LoaiMA
INTO v_Diemdoi, v_Phantram, v_LoaiMA
FROM Voucher
WHERE Code_Voucher = NEW.Code_Voucher;

CALL KH_TruDTL(NEW.ID_KH, v_Diemdoi);
CALL Voucher_GiamSL(NEW.Code_Voucher);

IF v_LoaiMA = 'All' THEN
            TongtienLoaiMonAnduocgiam := NEW.TienMonAn;
ELSE
SELECT COALESCE(SUM(ct.Thanhtien), 0) INTO TongtienLoaiMonAnduocgiam
FROM CTHD ct
         JOIN MonAn ma ON ma.ID_MonAn = ct.ID_MonAn
WHERE ct.ID_HoaDon = NEW.ID_HoaDon AND ma.Loai = v_LoaiMA;
END IF;

        NEW.TienGiam := ROUND(TongtienLoaiMonAnduocgiam * v_Phantram / 100);
        NEW.Tongtien := NEW.TienMonAn - NEW.TienGiam;
ELSE
        RAISE EXCEPTION 'Voucher khong ton tai';
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_HD_DoiVoucher
    BEFORE UPDATE OF Code_Voucher ON HoaDon
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_HD_DoiVoucher();


-- Trigger: Doanh so va Diem tich luy KhachHang khi hoa don 'Da thanh toan'
CREATE OR REPLACE FUNCTION fn_Tg_KH_DoanhsovaDTL()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Trangthai = 'Da thanh toan' THEN
UPDATE KhachHang SET Doanhso     = Doanhso     + NEW.Tongtien                      WHERE ID_KH = NEW.ID_KH;
UPDATE KhachHang SET Diemtichluy = Diemtichluy + ROUND(NEW.Tongtien * 0.00005)     WHERE ID_KH = NEW.ID_KH;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_KH_DoanhsovaDTL
    AFTER UPDATE OF Trangthai ON HoaDon
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_KH_DoanhsovaDTL();


-- Trigger: Trang thai Ban thay doi theo HoaDon
CREATE OR REPLACE FUNCTION fn_Tg_TrangthaiBan()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Trangthai = 'Chua thanh toan' THEN
UPDATE Ban SET Trangthai = 'Dang dung bua' WHERE ID_Ban = NEW.ID_Ban;
ELSE
UPDATE Ban SET Trangthai = 'Con trong'     WHERE ID_Ban = NEW.ID_Ban;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_TrangthaiBan
    AFTER INSERT OR UPDATE OF Trangthai ON HoaDon
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_TrangthaiBan();


-- Trigger: Thanh tien o CTNK = SoLuong x DonGia
CREATE OR REPLACE FUNCTION fn_Tg_CTNK_Thanhtien()
RETURNS TRIGGER AS $$
DECLARE
gia NUMERIC;
BEGIN
SELECT DonGia INTO gia FROM NguyenLieu WHERE ID_NL = NEW.ID_NL;
NEW.ThanhTien := NEW.SoLuong * gia;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_CTNK_Thanhtien
    BEFORE INSERT OR UPDATE OF SoLuong ON CTNK
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_CTNK_Thanhtien();


-- Trigger: Tongtien o PhieuNK = tong ThanhTien o CTNK
CREATE OR REPLACE FUNCTION fn_Tg_PNK_Tongtien()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
UPDATE PhieuNK SET Tongtien = Tongtien + NEW.ThanhTien WHERE ID_NK = NEW.ID_NK;
ELSIF TG_OP = 'UPDATE' THEN
UPDATE PhieuNK SET Tongtien = Tongtien + NEW.ThanhTien - OLD.ThanhTien WHERE ID_NK = NEW.ID_NK;
ELSIF TG_OP = 'DELETE' THEN
UPDATE PhieuNK SET Tongtien = Tongtien - OLD.ThanhTien WHERE ID_NK = OLD.ID_NK;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_PNK_Tongtien
    AFTER INSERT OR UPDATE OR DELETE ON CTNK
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_PNK_Tongtien();


-- Trigger: Cap nhat SLTon trong Kho khi them CTNK
CREATE OR REPLACE FUNCTION fn_Tg_Kho_ThemSLTon()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
UPDATE Kho SET SLTon = SLTon + NEW.SoLuong WHERE ID_NL = NEW.ID_NL;
ELSIF TG_OP = 'UPDATE' THEN
UPDATE Kho SET SLTon = SLTon + NEW.SoLuong - OLD.SoLuong WHERE ID_NL = NEW.ID_NL;
ELSIF TG_OP = 'DELETE' THEN
UPDATE Kho SET SLTon = SLTon - OLD.SoLuong WHERE ID_NL = OLD.ID_NL;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_Kho_ThemSLTon
    AFTER INSERT OR DELETE OR UPDATE OF SoLuong ON CTNK
FOR EACH ROW EXECUTE FUNCTION fn_Tg_Kho_ThemSLTon();


-- Trigger: Giam SLTon trong Kho khi them CTXK
CREATE OR REPLACE FUNCTION fn_Tg_Kho_GiamSLTon()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
UPDATE Kho SET SLTon = SLTon - NEW.SoLuong WHERE ID_NL = NEW.ID_NL;
ELSIF TG_OP = 'UPDATE' THEN
UPDATE Kho SET SLTon = SLTon - NEW.SoLuong + OLD.SoLuong WHERE ID_NL = NEW.ID_NL;
ELSIF TG_OP = 'DELETE' THEN
UPDATE Kho SET SLTon = SLTon + OLD.SoLuong WHERE ID_NL = OLD.ID_NL;
END IF;
RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_Kho_GiamSLTon
    AFTER INSERT OR DELETE OR UPDATE OF SoLuong ON CTXK
FOR EACH ROW EXECUTE FUNCTION fn_Tg_Kho_GiamSLTon();


-- Trigger: Khi them NguyenLieu moi thi them vao Kho
CREATE OR REPLACE FUNCTION fn_Tg_Kho_ThemNL()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO Kho(ID_NL) VALUES (NEW.ID_NL);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Tg_Kho_ThemNL
    AFTER INSERT ON NguyenLieu
    FOR EACH ROW EXECUTE FUNCTION fn_Tg_Kho_ThemNL();


-- ============================================================
-- INSERT DATA
-- ============================================================

-- Tat trigger de tranh loi khi insert du lieu mau
ALTER TABLE HoaDon    DISABLE TRIGGER ALL;
ALTER TABLE CTHD      DISABLE TRIGGER ALL;
ALTER TABLE KhachHang DISABLE TRIGGER ALL;
ALTER TABLE Ban       DISABLE TRIGGER ALL;
ALTER TABLE PhieuNK   DISABLE TRIGGER ALL;
ALTER TABLE CTNK      DISABLE TRIGGER ALL;
ALTER TABLE PhieuXK   DISABLE TRIGGER ALL;
ALTER TABLE CTXK      DISABLE TRIGGER ALL;

-- NguoiDung
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (100,'NVHoangViet@gmail.com','123','Verified','Quan Ly');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (101,'NVHoangPhuc@gmail.com','123','Verified','Nhan Vien');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (102,'NVAnhHong@gmail.com','123','Verified','Nhan Vien Kho');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (103,'NVQuangDinh@gmail.com','123','Verified','Nhan Vien');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (104,'KHThaoDuong@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (105,'KHTanHieu@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (106,'KHQuocThinh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (107,'KHNhuMai@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (108,'KHBichHao@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (109,'KHMaiQuynh@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (110,'KHMinhQuang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (111,'KHThanhHang@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (112,'KHThanhNhan@gmail.com','123','Verified','Khach Hang');
INSERT INTO NguoiDung(ID_ND,Email,MatKhau,Trangthai,Vaitro) VALUES (113,'KHPhucNguyen@gmail.com','123','Verified','Khach Hang');

-- NhanVien
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (100,'Nguyen Hoang Viet','2023-05-10','0848044725','Quan ly',100,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (101,'Nguyen Hoang Phuc','2023-05-20','0838033334','Tiep tan',101,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (102,'Le Thi Anh Hong','2023-05-19','0838033234','Kho',102,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_ND,ID_NQL,Tinhtrang) VALUES (103,'Ho Quang Dinh','2023-05-19','0838033234','Tiep tan',103,100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (104,'Ha Thao Duong','2023-05-10','0838033232','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (105,'Nguyen Quoc Thinh','2023-05-11','0838033734','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (106,'Truong Tan Hieu','2023-05-12','0838033834','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (107,'Nguyen Thai Bao','2023-05-10','0838093234','Phuc vu',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (108,'Tran Nhat Khang','2023-05-11','0838133234','Thu ngan',100,'Dang lam viec');
INSERT INTO NhanVien(ID_NV,TenNV,NgayVL,SDT,Chucvu,ID_NQL,Tinhtrang) VALUES (109,'Nguyen Ngoc Luong','2023-05-12','0834033234','Bep',100,'Dang lam viec');

-- KhachHang
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (100,'Ha Thao Duong','2023-05-10',104);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (101,'Truong Tan Hieu','2023-05-10',105);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (102,'Nguyen Quoc Thinh','2023-05-10',106);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (103,'Tran Nhu Mai','2023-05-10',107);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (104,'Nguyen Thi Bich Hao','2023-05-10',108);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (105,'Nguyen Mai Quynh','2023-05-11',109);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (106,'Hoang Minh Quang','2023-05-11',110);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (107,'Nguyen Thanh Hang','2023-05-12',111);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (108,'Nguyen Ngoc Thanh Nhan','2023-05-11',112);
INSERT INTO KhachHang(ID_KH,TenKH,Ngaythamgia,ID_ND) VALUES (109,'Hoang Thi Phuc Nguyen','2023-05-12',113);

-- MonAn (Aries)
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(1,'DUI CUU NUONG XE NHO',250000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(2,'BE SUON CUU NUONG GIAY BAC MONG CO',230000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(3,'DUI CUU NUONG TRUNG DONG',350000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(4,'CUU XOC LA CA RI',129000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(5,'CUU KUNGBAO',250000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(6,'BAP CUU NUONG CAY',250000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(7,'CUU VIEN HAM CAY',19000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(8,'SUON CONG NUONG MONG CO',250000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(9,'DUI CUU LON NUONG TAI BAN',750000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(10,'SUONG CUU NUONG SOT NAM',450000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(11,'DUI CUU NUONG TIEU XANH',285000,'Aries','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(12,'SUON CUU SOT PHO MAI',450000,'Aries','Dang kinh doanh');
-- Taurus
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(13,'Bit tet bo My khoai tay',179000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(14,'Bo bit tet Uc',169000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(15,'Bit tet bo My BASIC',179000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(16,'My Y bo bam',169000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(17,'Thit suon Wagyu',1180000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(18,'Steak Thit Vai Wagyu',1290000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(19,'Steak Thit Bung Bo',550000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(20,'Tomahawk',2390000,'Taurus','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(21,'Salad Romaine Nuong',180000,'Taurus','Dang kinh doanh');
-- Gemini
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(22,'Combo Happy',180000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(23,'Combo Fantastic',190000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(24,'Combo Dreamer',230000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(25,'Combo Cupid',180000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(26,'Combo Poseidon',190000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(27,'Combo LUANG PRABANG',490000,'Gemini','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(28,'Combo VIENTIANE',620000,'Gemini','Dang kinh doanh');
-- Cancer
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(29,'Cua KingCrab Duc sot',3650000,'Cancer','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(30,'Mai Cua KingCrab Topping Pho Mai',2650000,'Cancer','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(31,'Cua KingCrab sot Tu Xuyen',2300000,'Cancer','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(32,'Cua KingCrab Nuong Tu Nhien',2550000,'Cancer','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(33,'Cua KingCrab Nuong Bo Toi',2650000,'Cancer','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(34,'Com Mai Cua KingCrab Chien',1850000,'Cancer','Dang kinh doanh');
-- Leo
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(35,'BOSSAM',650000,'Leo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(36,'KIMCHI PANCAKE',350000,'Leo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(37,'SPICY RICE CAKE',250000,'Leo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(38,'SPICY SAUSAGE HOTPOT',650000,'Leo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(39,'SPICY PORK',350000,'Leo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(40,'MUSHROOM SPICY SILKY TOFU STEW',350000,'Leo','Dang kinh doanh');
-- Virgo
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(41,'Pavlova',150000,'Virgo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(42,'Kesutera',120000,'Virgo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(43,'Cremeschnitte',250000,'Virgo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(44,'Sachertorte',150000,'Virgo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(45,'Schwarzwalder Kirschtorte',250000,'Virgo','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(46,'New York-Style Cheesecake',250000,'Virgo','Dang kinh doanh');
-- Libra
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(47,'Cobb Salad',150000,'Libra','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(48,'Salad Israeli',120000,'Libra','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(49,'Salad Dau den',120000,'Libra','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(50,'Waldorf Salad',160000,'Libra','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(51,'Salad Gado-Gado',200000,'Libra','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(52,'Nicoise Salad',250000,'Libra','Dang kinh doanh');
-- Scorpio
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(53,'BULGOGI LUNCHBOX',250000,'Scorpio','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(54,'CHICKEN TERIYAKI LUNCHBOX',350000,'Scorpio','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(55,'SPICY PORK LUNCHBOX',350000,'Scorpio','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(56,'TOFU TERIYAKI LUNCHBOX',250000,'Scorpio','Dang kinh doanh');
-- Sagittarius
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(57,'Thit ngua do tuoi',250000,'Sagittarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(58,'Steak Thit ngua',350000,'Sagittarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(59,'Thit ngua ban gang',350000,'Sagittarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(60,'Long ngua xao dua',150000,'Sagittarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(61,'Thit ngua xao sa ot',250000,'Sagittarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(62,'Ngua tang',350000,'Sagittarius','Dang kinh doanh');
-- Capricorn
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(63,'Thit de xong hoi',229000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(64,'Thit de xao rau ngo',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(65,'Thit de nuong tang',229000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(66,'Thit de chao',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(67,'Thit de nuong xien',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(68,'Nam de nuong/chao',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(69,'Thit de xao lan',19000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(70,'Dui de tan thuoc bac',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(71,'Canh de ham duong quy',199000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(72,'Chao de dau xanh',50000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(73,'Thit de nhung me',229000,'Capricorn','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(74,'Lau de nhu',499000,'Capricorn','Dang kinh doanh');
-- Aquarius
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(75,'SIGNATURE WINE',3290000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(76,'CHILEAN WINE',3990000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(77,'ARGENTINA WINE',2890000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(78,'ITALIAN WINE',5590000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(79,'AMERICAN WINE',4990000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(80,'CLASSIC COCKTAIL',200000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(81,'SIGNATURE COCKTAIL',250000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(82,'MOCKTAIL',160000,'Aquarius','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(83,'JAPANESE SAKE',1490000,'Aquarius','Dang kinh doanh');
-- Pisces
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(84,'Ca Hoi Ngam Tuong',289000,'Pisces','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(85,'Ca Ngu Ngam Tuong',289000,'Pisces','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(86,'IKURA:Trung ca hoi',189000,'Pisces','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(87,'KARIN:Sashimi Ca Ngu',149000,'Pisces','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(88,'KEIKO:Sashimi Ca Hoi',199000,'Pisces','Dang kinh doanh');
INSERT INTO MonAn(ID_MonAn,TenMon,Dongia,Loai,TrangThai) VALUES(89,'CHIYO:Sashimi Bung Ca Hoi',219000,'Pisces','Dang kinh doanh');

-- Ban (Tang 1)
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(100,'Ban T1.1','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(101,'Ban T1.2','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(102,'Ban T1.3','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(103,'Ban T1.4','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(104,'Ban T1.5','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(105,'Ban T1.6','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(106,'Ban T1.7','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(107,'Ban T1.8','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(108,'Ban T1.9','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(109,'Ban T1.10','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(110,'Ban T1.11','Tang 1','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(111,'Ban T1.12','Tang 1','Con trong');
-- Tang 2
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(112,'Ban T2.1','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(113,'Ban T2.2','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(114,'Ban T2.3','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(115,'Ban T2.4','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(116,'Ban T2.5','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(117,'Ban T2.6','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(118,'Ban T2.7','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(119,'Ban T2.8','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(120,'Ban T2.9','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(121,'Ban T2.10','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(122,'Ban T2.11','Tang 2','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(123,'Ban T2.12','Tang 2','Con trong');
-- Tang 3
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(124,'Ban T3.1','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(125,'Ban T3.2','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(126,'Ban T3.3','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(127,'Ban T3.4','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(128,'Ban T3.5','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(129,'Ban T3.6','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(130,'Ban T3.7','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(131,'Ban T3.8','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(132,'Ban T3.9','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(133,'Ban T3.10','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(134,'Ban T3.11','Tang 3','Con trong');
INSERT INTO Ban(ID_Ban,TenBan,Vitri,Trangthai) VALUES(135,'Ban T3.12','Tang 3','Con trong');

-- Voucher
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('loQy','20% off for Aries Menu',20,'Aries',10,200);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('pCfI','30% off for Taurus Menu',30,'Taurus',5,300);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('pApo','20% off for Gemini Menu',20,'Gemini',10,200);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('ugQx','100% off for Virgo Menu',100,'Virgo',3,500);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('nxVX','20% off for All Menu',20,'All',5,300);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('Pwyn','20% off for Cancer Menu',20,'Cancer',10,200);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('bjff','50% off for Leo Menu',50,'Leo',5,600);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('YPzJ','20% off for Aquarius Menu',20,'Aquarius',5,200);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('Y5g0','30% off for Pisces Menu',30,'Pisces',5,300);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('7hVO','60% off for Aries Menu',60,'Aries',0,1000);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('WHLm','20% off for Capricorn Menu',20,'Capricorn',0,200);
INSERT INTO Voucher(Code_Voucher,Mota,Phantram,LoaiMA,SoLuong,Diem) VALUES ('GTsC','20% off for Leo Menu',20,'Leo',0,200);

-- HoaDon
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (101,100,100,'2023-01-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (102,104,102,'2023-01-15',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (103,105,103,'2023-01-20',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (104,101,101,'2023-02-13',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (105,103,120,'2023-02-12',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (106,104,100,'2023-03-16',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (107,107,103,'2023-03-20',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (108,108,101,'2023-04-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (109,100,100,'2023-04-20',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (110,103,101,'2023-05-05',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (111,106,102,'2023-05-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (112,108,103,'2023-05-15',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (113,106,102,'2023-05-20',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (114,108,103,'2023-06-05',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (115,109,104,'2023-06-07',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (116,100,105,'2023-06-07',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (117,106,106,'2023-06-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (118,102,106,'2023-02-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (119,103,106,'2023-02-12',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (120,104,106,'2023-04-10',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (121,105,106,'2023-04-12',0,0,'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon,ID_KH,ID_Ban,NgayHD,TienMonAn,TienGiam,Trangthai) VALUES (122,107,106,'2023-05-12',0,0,'Chua thanh toan');

-- CTHD
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,3,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (101,10,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,1,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,2,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (102,4,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (103,12,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,30,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (104,59,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,28,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (105,88,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,70,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,75,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (106,78,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,32,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (107,12,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,12,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (108,40,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (109,45,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,34,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (110,43,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,65,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (111,47,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,49,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (112,31,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (113,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,30,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (114,32,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (115,80,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,57,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (116,34,1);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,67,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (117,66,3);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,34,10);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (118,35,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,83,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (119,78,2);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,38,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (120,39,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,53,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (121,31,4);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,33,5);
INSERT INTO CTHD(ID_HoaDon,ID_MonAn,SoLuong) VALUES (122,34,6);

UPDATE HoaDon SET TrangThai = 'Da thanh toan';

-- Bat lai tat ca trigger sau khi insert xong du lieu mau
ALTER TABLE HoaDon    ENABLE TRIGGER ALL;
ALTER TABLE CTHD      ENABLE TRIGGER ALL;
ALTER TABLE KhachHang ENABLE TRIGGER ALL;
ALTER TABLE Ban       ENABLE TRIGGER ALL;
ALTER TABLE PhieuNK   ENABLE TRIGGER ALL;
ALTER TABLE CTNK      ENABLE TRIGGER ALL;
ALTER TABLE PhieuXK   ENABLE TRIGGER ALL;
ALTER TABLE CTXK      ENABLE TRIGGER ALL;

-- NguyenLieu
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(100,'Thit ga',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(101,'Thit heo',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(102,'Thit bo',80000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(103,'Tom',100000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(104,'Ca hoi',500000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(105,'Gao',40000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(106,'Sua tuoi',40000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(107,'Bot mi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(108,'Dau ca hoi',1000000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(109,'Dau dau nanh',150000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(110,'Muoi',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(111,'Duong',20000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(112,'Hanh tay',50000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(113,'Toi',30000,'kg');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(114,'Dam',50000,'l');
INSERT INTO NguyenLieu(ID_NL,TenNL,Dongia,Donvitinh) VALUES(115,'Thit de',130000,'kg');

-- PhieuNK
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (100,102,'2023-01-10');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (101,102,'2023-02-11');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (102,102,'2023-02-12');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (103,102,'2023-03-12');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (104,102,'2023-03-15');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (105,102,'2023-04-12');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (106,102,'2023-04-15');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (107,102,'2023-05-12');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (108,102,'2023-05-15');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (109,102,'2023-06-05');
INSERT INTO PhieuNK(ID_NK,ID_NV,NgayNK) VALUES (110,102,'2023-06-07');

-- CTNK
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,100,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,101,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (100,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,101,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,103,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,104,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,105,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,106,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,107,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (101,108,5);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,109,10);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,110,20);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (102,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (103,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (104,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (105,110,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,102,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (106,115,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,110,35);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (107,105,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,104,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,103,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (108,106,30);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,112,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,113,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (109,114,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,102,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,106,25);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,107,15);
INSERT INTO CTNK(ID_NK,ID_NL,SoLuong) VALUES (110,110,20);

-- PhieuXK
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (100,102,'2023-01-10');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (101,102,'2023-02-11');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (102,102,'2023-03-12');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (103,102,'2023-03-13');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (104,102,'2023-04-12');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (105,102,'2023-04-13');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (106,102,'2023-05-12');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (107,102,'2023-05-15');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (108,102,'2023-05-20');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (109,102,'2023-06-05');
INSERT INTO PhieuXK(ID_XK,ID_NV,NgayXK) VALUES (110,102,'2023-06-10');

-- CTXK
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,100,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (100,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,101,7);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,103,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,106,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,109,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,112,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,113,8);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,103,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,106,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,115,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,114,5);