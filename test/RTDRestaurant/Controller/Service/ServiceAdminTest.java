package RTDRestaurant.Controller.Service;

import RTDRestaurant.Controller.Connection.DatabaseConnection;
import RTDRestaurant.Model.ModelChart;
import RTDRestaurant.Model.ModelHoaDon;
import RTDRestaurant.Model.ModelMonAn;
import RTDRestaurant.Model.ModelNhanVien;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.swing.ImageIcon;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class ServiceAdminTest {

    Connection con;
    ServiceAdmin serviceAdmin;

    private ServiceAdmin sa;
    private ServiceStaff ss;
    private ServiceCustomer sc;

    public ServiceAdminTest() {
    }

    /**
     * Hàm setUp() - Thiết lập kết nối DB và khởi tạo ServiceAdmin
     */
    @Before
    public void setUp() throws SQLException {
        DatabaseConnection dbConnection = DatabaseConnection.getInstance();
        dbConnection.connectToDatabase();
        con = dbConnection.getConnection();
        serviceAdmin = new ServiceAdmin();

        sa = new ServiceAdmin();
        ss = new ServiceStaff();
        sc = new ServiceCustomer();
    }

    ////////////////////////////////////
    // Test hàm getListNV()
    @Test // AD_01
    public void testGetListNV() throws Exception {
        // Trong DB có 10 nhân viên
        ArrayList<ModelNhanVien> arr = sa.getListNV();
        assertEquals(10, arr.size());
    }

    ///////////////////////////////////
    // Test hàm getNV() lấy nhân viên từ id
    @Test // AD_02
    public void testGetNV_testChuan() throws Exception {
        // ID nhân viên 100 - 109
        ModelNhanVien nv = sa.getNV(100);
        assertNotNull(nv);
        assertEquals(100, nv.getId_NV());
    }

    @Test // AD_03
    public void testGetNV_IdBangKhong() throws Exception {
        ModelNhanVien nv = sa.getNV(0);
        assertNull(nv);
    }

    @Test // AD_04
    public void testGetNV_IdKhongTonTai() throws Exception {
        ModelNhanVien nv = sa.getNV(999);
        assertNull(nv);
    }

    @Test // AD_05
    public void testGetNV_IdSoAM() throws Exception {
        ModelNhanVien nv = sa.getNV(-99);
        assertNull(nv);
    }

    /////////////////////////////////////////////////////////
    // Test hàm getNextID_NV()
    @Test // AD_06
    public void testGetNextID_NV() throws SQLException {
        int next_Id = sa.getNextID_NV();
        // Trong DB id max = 109
        assertEquals(110, next_Id);
    }

    /////////////////////////////////////////////////////////////
    // Test hàm insertNV()
    @Test // AD_07
    public void testInsertNV_testChuan() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(110, "Chan Be Du", "07-04-2025", "0123456789", "Bep", 100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);
            sa.getNV(110);

            assertNotNull(nv);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_08
    public void testInsertNV_IDDaTonTai() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(109, "Chan Be Du", "07-04-2025", "0123456789", "Bep", 100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);

            fail("ID đã tồn tại mà vẫn thêm được");
        } catch (SQLException e) {
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_09
    public void testInsertNV_DuLieuKhongHopLe() throws Exception {
        // Không có chức vụ "Lái xe"
        ModelNhanVien nv = new ModelNhanVien(110, "Chan Be Du", "07-04-2025", "0123456789", "Lai xe", 100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);

            fail("Sai chức vụ mà vẫn thêm được");
        } catch (SQLException e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_10
    public void testInsertNV_KhuyetTruongBatBuoc() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(110, null, "07-04-2025", "0123456789", "Bep", 100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);

            fail("Thiếu trường tên nhân viên mà vẫn thêm được");
        } catch (Exception e) {
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_11
    public void testInsertNV_SaiDinhDang() throws Exception {
        // Định dạng ngày tháng đúng là dd-mm-yyyy
        ModelNhanVien nv = new ModelNhanVien(110, "Chan Be Du", "07/04/2025", "0123456789", "Bep", 100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);

            fail("Sai định dạng ngày tháng mà vẫn thêm được");
        } catch (SQLException e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_12
    public void testInsertNV_TenNhanVienQuaDai() throws Exception {
        // Tên nhân viên hơn 50 ký tự
        ModelNhanVien nv = new ModelNhanVien(
                110,
                "Chan Be Du Chan Be Du Chan Be Du Chan Be Du Chan Be Du Chan Be Du Chan Be Du",
                "07-04-2025",
                "0123456789",
                "Bep",
                100);

        try {
            con.setAutoCommit(false);
            sa.insertNV(nv);

            fail("Tên nhân viên hơn 50 ký mà vẫn thêm được");
        } catch (SQLException e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////
    // Test updateNV()
    @Test // AD_13
    public void testUpdateNV_testChuan() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                100,
                "Nguyen Hoang Viet",
                "10-05-2023",
                "0123456789789",
                "Quan ly",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);

            ModelNhanVien after = sa.getNV(100);

            assertEquals(nv.getId_NV(), after.getId_NV());
            assertEquals(nv.getTenNV(), after.getTenNV());
            assertEquals(nv.getNgayVL(), after.getNgayVL());
            assertEquals(nv.getChucvu(), after.getChucvu());
            assertEquals(nv.getId_NQL(), after.getId_NQL());

        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_14
    public void testUpdateNV_DuLieuKhongDoi() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                100,
                "Nguyen Hoang Viet2",
                "10-05-2023",
                "0123456789789",
                "Quan ly",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);

            ModelNhanVien after = sa.getNV(100);

            assertEquals(nv.getId_NV(), after.getId_NV());
            assertEquals(nv.getTenNV(), after.getTenNV());
            assertEquals(nv.getNgayVL(), after.getNgayVL());
            assertEquals(nv.getChucvu(), after.getChucvu());
            assertEquals(nv.getId_NQL(), after.getId_NQL());

        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_15
    public void testUpdateNV_KhuyetMotSoTruong() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                100,
                "Nguyen Hoang Viet",
                "10-05-2023",
                null,
                "Quan ly",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);
        } catch (SQLException e) {
            // PostgreSQL có thể ném PSQLException nếu cột bị ràng buộc NOT NULL/constraint.
            // Bắt SQLException chung để test không bị Error do khác DBMS.
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_16
    public void testUpdateNV_TenNhanVienQuaDai() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                100,
                "Nguyen Hoang Viet Nguyen Hoang Viet Nguyen Hoang Viet Nguyen Hoang Viet Nguyen Hoang Viet Nguyen Hoang Viet",
                "10-05-2023",
                "0123456789789",
                "Quan ly",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);
            fail("Expected SQLException was not thrown");
        } catch (SQLException e) {
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_17
    public void testUpdateNV_TruongDuLieuKhongHopLe() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                100,
                "Nguyen Hoang Viet",
                "10-05-2023",
                "0123456789789",
                "Lai xe",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);
            fail("Expected SQLException was not thrown");
        } catch (SQLException e) {
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_18
    public void testUpdateNV_IDBangKhong() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                0,
                "Nguyen Hoang Viet",
                "10-05-2023",
                "0123456789789",
                "Lai xe",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);
            fail("Expected SQLException was not thrown");
        } catch (SQLException e) {
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_19
    public void testUpdateNV_IDKhongTonTai() throws Exception {
        ModelNhanVien nv = new ModelNhanVien(
                99999,
                "Nguyen Hoang Viet",
                "10-05-2023",
                "0123456789789",
                "Lai xe",
                100);

        try {
            con.setAutoCommit(false);
            sa.updateNV(nv);
            fail("Expected SQLException was not thrown");
        } catch (SQLException e) {
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////
    // Test hàm getListHDIn()
    @Test // AD_20
    public void testGetListHDIn_TatCa() throws SQLException {
        ArrayList<ModelHoaDon> list = serviceAdmin.getListHDIn("Tất cả");

        assertNotNull("Fail: Danh sách hoá đơn không được null khi truyền 'Tất cả'", list);
    }

    @Test // AD_21
    public void testGetListHDIn_HomNay() throws SQLException {
        ArrayList<ModelHoaDon> list = serviceAdmin.getListHDIn("Hôm nay");

        assertNotNull("Fail: Danh sách hoá đơn hôm nay không được null", list);

        for (ModelHoaDon hd : list) {
            assertTrue(
                    "Fail: Ngày hoá đơn phải đúng là hôm nay",
                    hd.getNgayHD().equals(
                            java.time.LocalDate.now()
                                    .format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"))));
        }
    }

    @Test // AD_22
    public void testGetListHDIn_ThangNay() throws SQLException {
        ArrayList<ModelHoaDon> list = serviceAdmin.getListHDIn("Tháng này");

        assertNotNull("Fail: Danh sách hoá đơn tháng này không được null", list);
    }

    @Test // AD_23
    public void testGetListHDIn_NamNay() throws SQLException {
        ArrayList<ModelHoaDon> list = serviceAdmin.getListHDIn("Năm này");

        assertNotNull("Fail: Danh sách hoá đơn năm nay không được null", list);
    }

    @Test // AD_24
    public void testGetListHDIn_KhongHopLe() throws SQLException {
        try {
            serviceAdmin.getListHDIn("abc");

            fail("Fail: Phải ném ra IllegalArgumentException khi truyền tham số không hợp lệ, nhưng hiện tại code không xử lý.");
        } catch (IllegalArgumentException e) {
            assertEquals(
                    "Fail: Message ngoại lệ không đúng.",
                    "Giá trị truyền vào không hợp lệ! Chỉ cho phép: Tất cả, Hôm nay, Tháng này, Năm này.",
                    e.getMessage());
        } catch (Exception e) {
            fail("Fail: Phải ném ra IllegalArgumentException, nhưng lại ném Exception loại khác: "
                    + e.getClass().getSimpleName());
        }
    }

    ///////////////////////////////////////////////////////////////////////
    // Test hàm getRevenueHD()
    @Test // AD_25
    public void testGetRevenueHD_HomNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(26550000, sa.getRevenueHD("Hôm nay"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_26
    public void testGetRevenueHD_ThangNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(37000000, sa.getRevenueHD("Tháng này"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_27
    public void testGetRevenueHD_NamNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(41650000, sa.getRevenueHD("Năm này"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_28
    public void testGetRevenueHD_KhongHopLe() throws Exception {
        try {
            con.setAutoCommit(false);
            sa.getRevenueHD("Gia tri khong hop le");

            fail("Fail: Phải ném ra IllegalArgumentException khi truyền tham số không hợp lệ, nhưng hiện tại code không xử lý.");
        } catch (IllegalArgumentException e) {
            assertEquals(
                    "Fail: Message ngoại lệ không đúng.",
                    "Giá trị truyền vào không hợp lệ! Chỉ cho phép: Tất cả, Hôm nay, Tháng này, Năm này.",
                    e.getMessage());
        } catch (Exception e) {
            fail("Fail: Phải ném ra IllegalArgumentException, nhưng lại ném Exception loại khác: "
                    + e.getClass().getSimpleName());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    ////////////////////////////////////////////////////////////////
    // Test getPreMonthRevenueHD()
    // Lấy tổng doanh thu hóa đơn của tháng trước
    @Test // AD_29
    public void testGetPreMonthRevenueHD() throws Exception {
        try {
            con.setAutoCommit(false);
            assertNotNull(sa.getPreMonthRevenueHD());
            assertEquals(4650000, sa.getPreMonthRevenueHD());
        } catch (Exception e) {
            e.printStackTrace();
            fail("Không mong đợi exception ở testGetPreMonthRevenueHD: " + e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // Test getCostNK()
    // Lấy tổng chi phí nhập kho trong ngày/tháng/năm
    @Test // AD_30
    public void testGgetCostNK_HomNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(2600000, sa.getCostNK("Hôm nay"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_31
    public void testGgetCostNK_ThangNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(2900000, sa.getCostNK("Tháng này"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_32
    public void testGgetCostNK_NamNay() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(4600000, sa.getCostNK("Năm này"));
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_33
    public void testGgetCostNK_KhongHopLe() throws Exception {
        try {
            con.setAutoCommit(false);
            sa.getCostNK("Gia tri khong hop le");

            fail("Fail: Phải ném ra ngoại lệ khi truyền tham số không hợp lệ.");
        } catch (IllegalArgumentException e) {
            assertNotNull(e.getMessage());
        } catch (Exception e) {
            fail("Fail: Phải ném ra IllegalArgumentException, nhưng lại ném Exception loại khác: "
                    + e.getClass().getSimpleName());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Test getPreMonthCostNK()
    // Lấy tổng chi phí nhập kho của tháng trước
    @Test // AD_34
    public void testGetPreMonthCostNK() throws Exception {
        try {
            con.setAutoCommit(false);
            assertEquals(1700000, sa.getPreMonthCostNK());
        } catch (Exception e) {
            e.printStackTrace();
            fail("Không mong đợi exception ở testGetPreMonthCostNK: " + e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    ///////////////////////////////////////////////////////
    // Test hàm getRevenueCostProfit_byMonth()
    // Lấy toàn bộ doanh thu, chi phí, lợi nhuận của từng tháng trong năm
    @Test // AD_35
    public void testGetRevenueCostProfit_byMonth() throws Exception {
        try {
            con.setAutoCommit(false);
            ArrayList<ModelChart> results = sa.getRevenueCostProfit_byMonth();

            assertEquals(2, results.size());

            assertEquals("Thang 4", results.get(0).getLabel());
            assertEquals(4650000.0, results.get(0).getValues()[0], 0.1);
            assertEquals(1700000.0, results.get(0).getValues()[1], 0.1);
            assertEquals(2950000.0, results.get(0).getValues()[2], 0.1);

            assertEquals("Thang 5", results.get(1).getLabel());
            assertEquals(37000000.0, results.get(1).getValues()[0], 0.1);
            assertEquals(2900000.0, results.get(1).getValues()[1], 0.1);
            assertEquals(34100000.0, results.get(1).getValues()[2], 0.1);
        } catch (Exception e) {
            e.printStackTrace();
            fail("Không mong đợi exception ở testGetRevenueCostProfit_byMonth: " + e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    ///////////////////////////////////////////////////////
    // Test hàm getMenuFood()
    @Test // AD_36
    public void testGetMenuFood() throws Exception {
        // Thực đơn đang có 89 món ăn với id từ 1-89
        ArrayList<ModelMonAn> menu = sa.getMenuFood();

        assertNotNull(menu);
        assertEquals(89, menu.size());
    }

    ///////////////////////////////////////////////////////
    // Test hàm getNumberFood_inBusiness()
    @Test // AD_37
    public void testGetNumberFood_inBusiness() throws Exception {
        // Thực đơn đang có 89 món ăn đang kinh doanh
        int soluong = sa.getNumberFood_inBusiness();

        assertEquals(89, soluong);
    }

    /////////////////////////////////////////////////////////
    // Test hàm getNextID_MA()
    // Lấy id của món ăn được thêm tiếp
    @Test // AD_38
    public void testGetNextID_MA() throws SQLException {
        int next_Id = sa.getNextID_MA();
        // Trong DB id max = 89
        assertEquals(90, next_Id);
    }

    ////////////////////////////////////////////////////////////////
    @Test // AD_39
    public void testInsertMA_testChuan() throws Exception {
        // Thực đơn đang có 89 món ăn với id từ 1-89
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                90,
                "Thịt chó nấu rựa mận",
                350000,
                "Gemini",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.insertMA(ma);

            ArrayList<ModelMonAn> ma2 = sa.getMenuFood();

            assertNotNull(ma2);
            assertEquals(90, ma2.size());

        } catch (SQLException e) {
            fail(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_40
    public void testInsertMA_monAnDaTonTai() throws Exception {
        // Thực đơn đang có 89 món ăn với id từ 1-89
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                90,
                "DUI CUU NUONG XE NHO",
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.insertMA(ma);

            ArrayList<ModelMonAn> ma2 = sa.getMenuFood();

            assertNotNull(ma2);
            assertEquals(89, ma2.size());

        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_41
    public void testInsertMA_monAnRong() throws Exception {
        ModelMonAn ma = null;

        try {
            con.setAutoCommit(false);
            sa.insertMA(ma);

            fail("Món ăn rỗng mà vẫn thêm được");
        } catch (NullPointerException e) {
            e.printStackTrace();
            assertTrue(true);
        } catch (Exception e) {
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_42
    public void testInsertMA_monAnKhuyetMatTruongBatBuoc() throws Exception {
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                90,
                null,
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.insertMA(ma);

            fail("Món ăn không có tên mà vẫn thêm được");
        } catch (Exception e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_43
    public void testInsertMA_dinhDangDuLieuSai() throws Exception {
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                90,
                "Thịt chó nấu rựa mận",
                350000,
                "Sơn hào hải vị",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.insertMA(ma);

            fail("Loại món ăn không tồn tại mà vẫn thêm được");
        } catch (SQLException e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////
    // Test updateMonAn()
    @Test // AD_44
    public void testUpdateMonAn_testChuan() throws Exception {
        ArrayList<ModelMonAn> arr1 = sa.getMenuFood();

        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                1,
                "DUI CUU NUONG XE NHO",
                257000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            ArrayList<ModelMonAn> arr2 = sa.getMenuFood();

            assertEquals(arr1.size(), arr2.size());
            assertEquals(arr1.get(0).getId(), arr2.get(0).getId());
            assertNotEquals(arr1.get(0).getValue(), arr2.get(0).getValue());

        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_45
    public void testUpdateMonAn_duLieuKhongDoi() throws Exception {
        ArrayList<ModelMonAn> arr1 = sa.getMenuFood();

        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                1,
                "DUI CUU NUONG XE NHO",
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            ArrayList<ModelMonAn> arr2 = sa.getMenuFood();

            assertEquals(arr1.size(), arr2.size());
            assertEquals(arr1.get(0).getId(), arr2.get(0).getId());
            assertEquals(arr1.get(0).getValue(), arr2.get(0).getValue());

        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_46
    public void testUpdateMonAn_duLieuKhongHopLe() throws Exception {
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                1,
                "DUI CUU NUONG XE NHO",
                -250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            fail("Đơn giá âm");
        } catch (Exception e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_47
    public void testUpdateMonAn_IdBangKhong() throws Exception {
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                0,
                "DUI CUU NUONG XE NHO",
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            fail("ID = 0");
        } catch (Exception e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_48
    public void testUpdateMonAn_IdBangAm() throws Exception {
        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                -10,
                "DUI CUU NUONG XE NHO",
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            fail("ID âm");
        } catch (Exception e) {
            e.printStackTrace();
            assertTrue(true);
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_49
    public void testUpdateMonAn_TenBiTrung() throws Exception {
        ArrayList<ModelMonAn> arr = sa.getMenuFood();

        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                1,
                "DUI CUU NUONG XE NHO",
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            ArrayList<ModelMonAn> arr2 = sa.getMenuFood();

            assertNotEquals(arr.get(1).getTitle(), arr2.get(1).getTitle());

        } catch (SQLException e) {
            // Nếu DB chặn trùng tên/ràng buộc dữ liệu thì đây là kết quả mong đợi của
            // testcase âm tính.
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Test // AD_50
    public void testUpdateMonAn_khuyetMotSoTruong() throws Exception {
        ArrayList<ModelMonAn> arr = sa.getMenuFood();

        ModelMonAn ma = new ModelMonAn(
                new ImageIcon(getClass().getResource("/Icons/Food/Unknown/unknown.jpg")),
                1,
                null,
                250000,
                "Aries",
                "Dang kinh doanh");

        try {
            con.setAutoCommit(false);
            sa.UpdateMonAn(ma);

            ArrayList<ModelMonAn> arr2 = sa.getMenuFood();

            assertEquals(arr.size(), arr2.size());
            assertNotNull(arr2.get(0).getTitle());

        } catch (SQLException e) {
            // Trường bắt buộc bị null có thể bị PostgreSQL từ chối và ném PSQLException.
            e.printStackTrace();
            assertNotNull(e.getMessage());
        } finally {
            try {
                con.rollback();
                con.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}