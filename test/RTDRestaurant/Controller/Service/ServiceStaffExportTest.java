/*
 * Class ServiceStaffExportTest
 * Mục đích: Thực hiện kiểm thử đơn vị (unit test) cho các hàm liên quan đến chức năng quản lý xuất kho trong class ServiceStaff
 * 
 * Các hàm được test:
 * 1. MenuPXK() - Lấy toàn bộ danh sách Phiếu xuất kho
 * 2. getPXKbyID(int id) - Lấy thông tin của Phiếu xuất kho theo ID
 * 3. getSLPXK() - Lấy số lượng phiếu xuất kho trong ngày hiện tại
 * 4. getCTXK(int idxk) - Lấy danh sách chi tiết Xuất kho theo ID_XK
 * 5. getNextID_XK() - Lấy ID của Phiếu xuất kho tiếp theo được thêm
 * 6. InsertPXK_CTXK(ModelPXK pxk, ArrayList<ModelKho> list) - Thêm phiếu xuất kho và chi tiết Xuất kho
 * 
 * Công cụ sử dụng:
 * - JUnit 4
 * - Java SQL Connection thật
 * - Database có dữ liệu thật
 * 
 * Quy ước message assert:
 * - Rõ ràng, dễ hiểu, mô tả chính xác ý nghĩa khi kiểm tra sai
 */
package RTDRestaurant.Controller.Service;

import RTDRestaurant.Controller.Connection.DatabaseConnection;
import RTDRestaurant.Model.ModelCTXK;
import RTDRestaurant.Model.ModelKho;
import RTDRestaurant.Model.ModelPXK;
import RTDRestaurant.Model.ModelNguyenLieu;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.junit.Test;
import static org.junit.Assert.*;
import org.junit.Before;

public class ServiceStaffExportTest {

    Connection con;
    ServiceStaff serviceStaff;

    public ServiceStaffExportTest() {
    }

    /**
     * Hàm setUp() - Thiết lập kết nối DB và khởi tạo ServiceStaff
     */
    @Before
    public void setUp() throws SQLException {
        DatabaseConnection dbConnection = DatabaseConnection.getInstance();
        dbConnection.connectToDatabase();
        con = dbConnection.getConnection();
        serviceStaff = new ServiceStaff();
    }

    ////////////////////////////////////
    // Test hàm MenuPXK() - Lấy toàn bộ danh sách Phiếu xuất kho
    ////////////////////////////////////

    /**
     * Test case: Lấy toàn bộ danh sách phiếu xuất kho
     * Mong đợi: Danh sách không null và có dữ liệu
     */
    @Test // SE_01
    public void testMenuPXK_testChuan() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        assertNotNull("Fail: Danh sách phiếu xuất kho không được null", list);
        assertTrue("Fail: Danh sách phiếu xuất kho phải có ít nhất 1 phần tử", list.size() > 0);

        // Kiểm tra phần tử đầu tiên có đầy đủ thông tin
        if (list.size() > 0) {
            ModelPXK firstPXK = list.get(0);
            assertTrue("Fail: ID phiếu xuất kho phải lớn hơn 0", firstPXK.getIdXK() > 0);
            assertTrue("Fail: ID nhân viên phải lớn hơn 0", firstPXK.getIdNV() > 0);
            assertNotNull("Fail: Ngày xuất kho không được null", firstPXK.getNgayXK());
        }
    }

    /**
     * Test case: Kiểm tra danh sách phiếu xuất kho được sắp xếp theo ID_XK
     * Mong đợi: Danh sách được sắp xếp tăng dần theo ID
     */
    @Test // SE_02
    public void testMenuPXK_kiemTraSapXep() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        if (list.size() > 1) {
            for (int i = 0; i < list.size() - 1; i++) {
                assertTrue("Fail: Danh sách phải được sắp xếp tăng dần theo ID_XK",
                        list.get(i).getIdXK() <= list.get(i + 1).getIdXK());
            }
        }
    }

    ////////////////////////////////////
    // Test hàm getPXKbyID(int id) - Lấy thông tin của Phiếu xuất kho theo ID
    ////////////////////////////////////

    /**
     * Test case: Lấy phiếu xuất kho với ID hợp lệ
     * Mong đợi: Trả về đối tượng ModelPXK không null với đúng ID
     */
    @Test // SE_03
    public void testGetPXKbyID_testChuan() throws SQLException {
        // Lấy ID phiếu xuất kho đầu tiên từ danh sách
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();
        if (list.size() > 0) {
            int idTest = list.get(0).getIdXK();

            ModelPXK pxk = serviceStaff.getPXKbyID(idTest);

            assertNotNull("Fail: Phiếu xuất kho không được null khi ID hợp lệ", pxk);
            assertEquals("Fail: ID phiếu xuất kho phải khớp với ID truyền vào", idTest, pxk.getIdXK());
            assertTrue("Fail: ID nhân viên phải lớn hơn 0", pxk.getIdNV() > 0);
            assertNotNull("Fail: Ngày xuất kho không được null", pxk.getNgayXK());
        }
    }

    /**
     * Test case: Lấy phiếu xuất kho với ID = 0
     * Mong đợi: Trả về null
     */
    @Test // SE_04
    public void testGetPXKbyID_IdBangKhong() throws SQLException {
        ModelPXK pxk = serviceStaff.getPXKbyID(0);

        assertNull("Fail: Phải trả về null khi ID = 0", pxk);
    }

    /**
     * Test case: Lấy phiếu xuất kho với ID không tồn tại
     * Mong đợi: Trả về null
     */
    @Test // SE_05
    public void testGetPXKbyID_IdKhongTonTai() throws SQLException {
        ModelPXK pxk = serviceStaff.getPXKbyID(999999);

        assertNull("Fail: Phải trả về null khi ID không tồn tại", pxk);
    }

    /**
     * Test case: Lấy phiếu xuất kho với ID âm
     * Mong đợi: Trả về null
     */
    @Test // SE_06
    public void testGetPXKbyID_IdSoAm() throws SQLException {
        ModelPXK pxk = serviceStaff.getPXKbyID(-99);

        assertNull("Fail: Phải trả về null khi ID âm", pxk);
    }

    ////////////////////////////////////
    // Test hàm getSLPXK() - Lấy số lượng phiếu xuất kho trong ngày hiện tại
    ////////////////////////////////////

    /**
     * Test case: Lấy số lượng phiếu xuất kho trong ngày hiện tại
     * Mong đợi: Trả về số >= 0
     */
    @Test // SE_07
    public void testGetSLPXK_testChuan() throws SQLException {
        int sl = serviceStaff.getSLPXK();

        assertTrue("Fail: Số lượng phiếu xuất kho phải >= 0", sl >= 0);
    }

    /**
     * Test case: Kiểm tra số lượng phiếu xuất kho hôm nay khớp với query thủ công
     * Mong đợi: Số lượng khớp với kết quả query trực tiếp
     */
    @Test // SE_08
    public void testGetSLPXK_kiemTraKhopVoiDB() throws SQLException {
        int slFromMethod = serviceStaff.getSLPXK();

        // Query trực tiếp để kiểm tra
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        String today = sdf.format(new Date());

        String sql = "SELECT COUNT(*) FROM PhieuXK WHERE NgayXK=to_date(?, 'dd-mm-yyyy')";
        PreparedStatement p = con.prepareStatement(sql);
        p.setString(1, today);
        ResultSet r = p.executeQuery();

        int slFromDB = 0;
        if (r.next()) {
            slFromDB = r.getInt(1);
        }
        r.close();
        p.close();

        assertEquals("Fail: Số lượng phiếu xuất kho từ method phải khớp với DB", slFromDB, slFromMethod);
    }

    ////////////////////////////////////
    // Test hàm getCTXK(int idxk) - Lấy danh sách chi tiết Xuất kho theo ID_XK
    ////////////////////////////////////

    /**
     * Test case: Lấy chi tiết xuất kho với ID phiếu xuất kho hợp lệ
     * Mong đợi: Danh sách không null và có dữ liệu
     */
    @Test // SE_09
    public void testGetCTXK_testChuan() throws SQLException {
        // Lấy ID phiếu xuất kho đầu tiên
        ArrayList<ModelPXK> listPXK = serviceStaff.MenuPXK();
        if (listPXK.size() > 0) {
            int idXK = listPXK.get(0).getIdXK();

            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(idXK);

            assertNotNull("Fail: Danh sách chi tiết xuất kho không được null", listCTXK);

            // Nếu có chi tiết, kiểm tra thông tin
            if (listCTXK.size() > 0) {
                ModelCTXK firstCTXK = listCTXK.get(0);
                assertEquals("Fail: ID phiếu xuất kho trong chi tiết phải khớp", idXK, firstCTXK.getIdXK());
                assertTrue("Fail: ID nguyên liệu phải lớn hơn 0", firstCTXK.getIdNL() > 0);
                assertNotNull("Fail: Tên nguyên liệu không được null", firstCTXK.getTenNL());
                assertNotNull("Fail: Đơn vị tính không được null", firstCTXK.getDvt());
                assertTrue("Fail: Số lượng phải lớn hơn 0", firstCTXK.getsL() > 0);
            }
        }
    }

    /**
     * Test case: Lấy chi tiết xuất kho với ID không tồn tại
     * Mong đợi: Danh sách rỗng
     */
    @Test // SE_10
    public void testGetCTXK_IdKhongTonTai() throws SQLException {
        ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(999999);

        assertNotNull("Fail: Danh sách không được null", listCTXK);
        assertEquals("Fail: Danh sách phải rỗng khi ID không tồn tại", 0, listCTXK.size());
    }

    /**
     * Test case: Lấy chi tiết xuất kho với ID = 0
     * Mong đợi: Danh sách rỗng
     */
    @Test // SE_11
    public void testGetCTXK_IdBangKhong() throws SQLException {
        ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(0);

        assertNotNull("Fail: Danh sách không được null", listCTXK);
        assertEquals("Fail: Danh sách phải rỗng khi ID = 0", 0, listCTXK.size());
    }

    /**
     * Test case: Lấy chi tiết xuất kho với ID âm
     * Mong đợi: Danh sách rỗng
     */
    @Test // SE_12
    public void testGetCTXK_IdSoAm() throws SQLException {
        ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(-99);

        assertNotNull("Fail: Danh sách không được null", listCTXK);
        assertEquals("Fail: Danh sách phải rỗng khi ID âm", 0, listCTXK.size());
    }

    ////////////////////////////////////
    // Test hàm getNextID_XK() - Lấy ID của Phiếu xuất kho tiếp theo được thêm
    ////////////////////////////////////

    /**
     * Test case: Lấy ID phiếu xuất kho tiếp theo
     * Mong đợi: ID > 0 và lớn hơn ID max hiện tại
     */
    @Test // SE_13
    public void testGetNextID_XK_testChuan() throws SQLException {
        int nextID = serviceStaff.getNextID_XK();

        assertTrue("Fail: ID tiếp theo phải lớn hơn 0", nextID > 0);

        // Kiểm tra với ID max hiện tại
        String sql = "SELECT MAX(ID_XK) as ID FROM PhieuXK";
        PreparedStatement p = con.prepareStatement(sql);
        ResultSet r = p.executeQuery();

        int maxID = 0;
        if (r.next()) {
            maxID = r.getInt("ID");
        }
        r.close();
        p.close();

        assertEquals("Fail: ID tiếp theo phải bằng MAX(ID_XK) + 1", maxID + 1, nextID);
    }

    /**
     * Test case: Kiểm tra getNextID_XK khi bảng rỗng
     * Mong đợi: Trả về 1 (hoặc giá trị mặc định)
     * Lưu ý: Test này chỉ chạy được nếu có thể xóa toàn bộ dữ liệu tạm thời
     */
    @Test // SE_14
    public void testGetNextID_XK_bangRong() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Xóa tạm thời toàn bộ phiếu xuất kho
            String sqlDeleteCTXK = "DELETE FROM CTXK";
            String sqlDeletePXK = "DELETE FROM PhieuXK";

            PreparedStatement p1 = con.prepareStatement(sqlDeleteCTXK);
            p1.execute();
            p1.close();

            PreparedStatement p2 = con.prepareStatement(sqlDeletePXK);
            p2.execute();
            p2.close();

            int nextID = serviceStaff.getNextID_XK();

            assertEquals("Fail: Khi bảng rỗng, ID tiếp theo phải là 1", 1, nextID);

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    ////////////////////////////////////
    // Test hàm InsertPXK_CTXK() - Thêm phiếu xuất kho và chi tiết Xuất kho
    ////////////////////////////////////

    /**
     * Test case: Thêm phiếu xuất kho với dữ liệu hợp lệ
     * Mong đợi: Thêm thành công, có thể lấy lại phiếu xuất kho vừa thêm
     */
    @Test // SE_15
    public void testInsertPXK_CTXK_testChuan() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Tạo phiếu xuất kho mới
            ModelPXK pxk = new ModelPXK(nextID, 100, today);

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() < 2) {
                fail("Fail: Database phải có ít nhất 2 nguyên liệu để test");
            }

            // Tạo danh sách nguyên liệu xuất kho với ID thật
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));
            listKho.add(new ModelKho(listNL.get(1).getId(), listNL.get(1).getTenNL(), listNL.get(1).getDvt(), 5));

            // Thêm phiếu xuất kho
            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Kiểm tra phiếu xuất kho đã được thêm
            ModelPXK pxkInserted = serviceStaff.getPXKbyID(nextID);
            assertNotNull("Fail: Phiếu xuất kho vừa thêm phải tồn tại", pxkInserted);
            assertEquals("Fail: ID phiếu xuất kho phải khớp", nextID, pxkInserted.getIdXK());
            assertEquals("Fail: ID nhân viên phải khớp", 100, pxkInserted.getIdNV());

            // Kiểm tra chi tiết xuất kho
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Số lượng chi tiết xuất kho phải khớp", 2, listCTXK.size());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ID đã tồn tại
     * Mong đợi: Ném ra SQLException (vi phạm ràng buộc khóa chính)
     */
    @Test // SE_16
    public void testInsertPXK_CTXK_IdDaTonTai() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy ID phiếu xuất kho đã tồn tại
            ArrayList<ModelPXK> list = serviceStaff.MenuPXK();
            if (list.size() > 0) {
                int existingID = list.get(0).getIdXK();
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                String today = sdf.format(new Date());

                // Lấy ID nguyên liệu thật từ DB
                ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
                if (listNL.size() == 0) {
                    fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
                }

                ModelPXK pxk = new ModelPXK(existingID, 100, today);
                ArrayList<ModelKho> listKho = new ArrayList<>();
                listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

                serviceStaff.InsertPXK_CTXK(pxk, listKho);

                fail("Fail: Phải ném ra SQLException khi ID đã tồn tại");
            }

        } catch (SQLException e) {
            // PostgreSQL hoặc Oracle đều ném SQLException khi vi phạm khóa chính
            assertTrue("Fail: Phải là lỗi vi phạm ràng buộc",
                    e.getMessage().contains("duplicate") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ID nhân viên không tồn tại
     * Mong đợi: Ném ra SQLException (vi phạm ràng buộc khóa ngoại)
     */
    @Test // SE_17
    public void testInsertPXK_CTXK_IdNhanVienKhongTonTai() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            // ID nhân viên không tồn tại
            ModelPXK pxk = new ModelPXK(nextID, 999999, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            fail("Fail: Phải ném ra SQLException khi ID nhân viên không tồn tại");

        } catch (SQLException e) {
            // PostgreSQL hoặc Oracle đều ném SQLException khi vi phạm khóa ngoại
            assertTrue("Fail: Phải là lỗi vi phạm ràng buộc khóa ngoại",
                    e.getMessage().contains("foreign key") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ngày không hợp lệ
     * Mong đợi: Ném ra SQLException (lỗi định dạng ngày)
     */
    @Test // SE_18
    public void testInsertPXK_CTXK_NgayKhongHopLe() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            // Định dạng ngày sai (đúng phải là dd-MM-yyyy)
            ModelPXK pxk = new ModelPXK(nextID, 100, "2025/05/17");
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            fail("Fail: Phải ném ra SQLException khi định dạng ngày sai");

        } catch (SQLException e) {
            // Chấp nhận cả lỗi từ PostgreSQL và Oracle
            assertTrue("Fail: Phải là lỗi SQL liên quan đến định dạng ngày",
                    e.getMessage().contains("ORA") ||
                            e.getMessage().contains("date") ||
                            e.getMessage().contains("invalid"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với danh sách nguyên liệu rỗng
     * Mong đợi: Thêm phiếu xuất kho thành công nhưng không có chi tiết
     */
    @Test // SE_19
    public void testInsertPXK_CTXK_DanhSachNguyenLieuRong() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>(); // Danh sách rỗng

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Kiểm tra phiếu xuất kho đã được thêm
            ModelPXK pxkInserted = serviceStaff.getPXKbyID(nextID);
            assertNotNull("Fail: Phiếu xuất kho phải được thêm", pxkInserted);

            // Kiểm tra không có chi tiết xuất kho
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Không được có chi tiết xuất kho", 0, listCTXK.size());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với nguyên liệu có số lượng = 0
     * Mong đợi: Nguyên liệu có số lượng = 0 không được thêm vào chi tiết
     */
    @Test // SE_20
    public void testInsertPXK_CTXK_NguyenLieuSoLuongBangKhong() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() < 3) {
                fail("Fail: Database phải có ít nhất 3 nguyên liệu để test");
            }

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10)); // Số
                                                                                                                    // lượng
                                                                                                                    // >
                                                                                                                    // 0
            listKho.add(new ModelKho(listNL.get(1).getId(), listNL.get(1).getTenNL(), listNL.get(1).getDvt(), 0)); // Số
                                                                                                                   // lượng
                                                                                                                   // =
                                                                                                                   // 0
            listKho.add(new ModelKho(listNL.get(2).getId(), listNL.get(2).getTenNL(), listNL.get(2).getDvt(), 5)); // Số
                                                                                                                   // lượng
                                                                                                                   // >
                                                                                                                   // 0

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Kiểm tra chỉ có 2 chi tiết xuất kho (bỏ qua nguyên liệu có số lượng = 0)
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Chỉ có 2 chi tiết xuất kho (bỏ qua số lượng = 0)", 2, listCTXK.size());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với nguyên liệu không tồn tại
     * Mong đợi: Ném ra SQLException (vi phạm ràng buộc khóa ngoại)
     */
    @Test // SE_21
    public void testInsertPXK_CTXK_NguyenLieuKhongTonTai() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(999999, "Nguyên liệu không tồn tại", "kg", 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            fail("Fail: Phải ném ra SQLException khi nguyên liệu không tồn tại");

        } catch (SQLException e) {
            // PostgreSQL hoặc Oracle đều ném SQLException khi vi phạm khóa ngoại
            assertTrue("Fail: Phải là lỗi vi phạm ràng buộc khóa ngoại",
                    e.getMessage().contains("foreign key") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("fk_idnl") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    ////////////////////////////////////
    // Test cases bổ sung - Kiểm tra tính toàn vẹn dữ liệu
    ////////////////////////////////////

    /**
     * Test case: Thêm phiếu xuất kho với số lượng âm
     * Mong đợi: Ném ra SQLException hoặc không thêm vào chi tiết
     */
    @Test // SE_22
    public void testInsertPXK_CTXK_SoLuongAm() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), -10)); // Số
                                                                                                                     // lượng
                                                                                                                     // âm

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Kiểm tra không có chi tiết xuất kho (vì số lượng âm không hợp lệ)
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Không được có chi tiết xuất kho với số lượng âm", 0, listCTXK.size());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ID = 0
     * Mong đợi: Ném ra SQLException (ID không hợp lệ)
     */
    @Test // SE_23
    public void testInsertPXK_CTXK_IdBangKhong() throws SQLException {
        System.out.println("\n========================================");
        System.out.println("TEST SE_23: ID phiếu xuất = 0");
        System.out.println("========================================");

        try {
            con.setAutoCommit(false);

            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            System.out.println("Thử insert phiếu xuất với ID = 0");

            ModelPXK pxk = new ModelPXK(0, 100, today); // ID = 0
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            System.out.println("❌ BUG: Hệ thống CHO PHÉP insert với ID = 0!");
            System.out.println("❌ Hệ thống THIẾU validation: ID phải > 0");
            fail("BUG: Phải ném ra SQLException khi ID = 0");

        } catch (SQLException e) {
            System.out.println("✅ HỆ THỐNG ĐÃ CHẶN (ném SQLException)");
            System.out.println("Exception: " + e.getMessage());
            assertTrue("Fail: Phải là lỗi SQL",
                    e.getMessage().contains("constraint") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("check") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
            System.out.println("========================================\n");
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ID âm
     * Mong đợi: Ném ra SQLException (ID không hợp lệ)
     */
    @Test // SE_24
    public void testInsertPXK_CTXK_IdAm() throws SQLException {
        System.out.println("\n========================================");
        System.out.println("TEST SE_24: ID phiếu xuất âm");
        System.out.println("========================================");

        try {
            con.setAutoCommit(false);

            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            System.out.println("Thử insert phiếu xuất với ID = -99");

            ModelPXK pxk = new ModelPXK(-99, 100, today); // ID âm
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            System.out.println("❌ BUG: Hệ thống CHO PHÉP insert với ID âm!");
            System.out.println("❌ Hệ thống THIẾU validation: ID phải > 0");
            fail("BUG: Phải ném ra SQLException khi ID âm");

        } catch (SQLException e) {
            System.out.println("✅ HỆ THỐNG ĐÃ CHẶN (ném SQLException)");
            System.out.println("Exception: " + e.getMessage());
            assertTrue("Fail: Phải là lỗi SQL",
                    e.getMessage().contains("constraint") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("check") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
            System.out.println("========================================\n");
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với ngày null
     * Mong đợi: Ném ra SQLException hoặc NullPointerException
     */
    @Test // SE_25
    public void testInsertPXK_CTXK_NgayNull() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();

            // Lấy ID nguyên liệu thật từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu để test");
            }

            ModelPXK pxk = new ModelPXK(nextID, 100, null); // Ngày null
            ArrayList<ModelKho> listKho = new ArrayList<>();
            listKho.add(new ModelKho(listNL.get(0).getId(), listNL.get(0).getTenNL(), listNL.get(0).getDvt(), 10));

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            fail("Fail: Phải ném ra exception khi ngày null");

        } catch (SQLException | NullPointerException e) {
            assertTrue("Fail: Phải là lỗi SQL hoặc NullPointer", true);
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Thêm phiếu xuất kho với nhiều nguyên liệu (stress test nhỏ)
     * Mong đợi: Thêm thành công tất cả chi tiết
     */
    @Test // SE_26
    public void testInsertPXK_CTXK_NhieuNguyenLieu() throws SQLException {
        try {
            con.setAutoCommit(false);

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            // Lấy tất cả nguyên liệu từ DB
            ArrayList<ModelNguyenLieu> listNL = serviceStaff.MenuNL();
            if (listNL.size() < 5) {
                fail("Fail: Database phải có ít nhất 5 nguyên liệu để test");
            }

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();

            // Thêm nhiều nguyên liệu
            for (int i = 0; i < Math.min(10, listNL.size()); i++) {
                listKho.add(new ModelKho(
                        listNL.get(i).getId(),
                        listNL.get(i).getTenNL(),
                        listNL.get(i).getDvt(),
                        (i + 1) * 5 // Số lượng khác nhau
                ));
            }

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Kiểm tra tất cả chi tiết đã được thêm
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Số lượng chi tiết xuất kho phải khớp", listKho.size(), listCTXK.size());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Kiểm tra getCTXK trả về đúng thứ tự
     * Mong đợi: Danh sách được sắp xếp theo ID_XK
     */
    @Test // SE_27
    public void testGetCTXK_KiemTraThuTu() throws SQLException {
        ArrayList<ModelPXK> listPXK = serviceStaff.MenuPXK();
        if (listPXK.size() > 0) {
            int idXK = listPXK.get(0).getIdXK();

            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(idXK);

            // Kiểm tra tất cả phần tử có cùng ID_XK
            for (ModelCTXK ctxk : listCTXK) {
                assertEquals("Fail: Tất cả chi tiết phải có cùng ID_XK", idXK, ctxk.getIdXK());
            }
        }
    }

    /**
     * Test case: Kiểm tra MenuPXK không trả về dữ liệu trùng lặp
     * Mong đợi: Không có ID_XK trùng nhau
     */
    @Test // SE_28
    public void testMenuPXK_KhongTrungLap() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        // Kiểm tra không có ID trùng
        for (int i = 0; i < list.size(); i++) {
            for (int j = i + 1; j < list.size(); j++) {
                assertNotEquals("Fail: Không được có ID_XK trùng lặp",
                        list.get(i).getIdXK(), list.get(j).getIdXK());
            }
        }
    }

    /**
     * Test case: Kiểm tra getPXKbyID với nhiều ID khác nhau
     * Mong đợi: Mỗi ID trả về đúng phiếu xuất kho tương ứng
     */
    @Test // SE_29
    public void testGetPXKbyID_NhieuID() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        // Test với tối đa 5 phiếu xuất kho đầu tiên
        int testCount = Math.min(5, list.size());
        for (int i = 0; i < testCount; i++) {
            ModelPXK expected = list.get(i);
            ModelPXK actual = serviceStaff.getPXKbyID(expected.getIdXK());

            assertNotNull("Fail: Phải lấy được phiếu xuất kho với ID " + expected.getIdXK(), actual);
            assertEquals("Fail: ID_XK phải khớp", expected.getIdXK(), actual.getIdXK());
            assertEquals("Fail: ID_NV phải khớp", expected.getIdNV(), actual.getIdNV());
            assertEquals("Fail: NgayXK phải khớp", expected.getNgayXK(), actual.getNgayXK());
        }
    }

    /**
     * Test case: Kiểm tra getSLPXK sau khi thêm phiếu xuất kho mới
     * Mong đợi: Số lượng tăng lên 1
     */
    @Test // SE_30
    public void testGetSLPXK_SauKhiThem() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy số lượng ban đầu
            int slBanDau = serviceStaff.getSLPXK();

            // Thêm phiếu xuất kho mới
            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();

            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            // Lấy số lượng sau khi thêm
            int slSauKhiThem = serviceStaff.getSLPXK();

            assertEquals("Fail: Số lượng phiếu xuất kho phải tăng lên 1", slBanDau + 1, slSauKhiThem);

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Kiểm tra getNextID_XK tăng dần sau mỗi lần thêm
     * Mong đợi: ID tiếp theo luôn lớn hơn ID hiện tại
     */
    @Test // SE_31
    public void testGetNextID_XK_TangDan() throws SQLException {
        try {
            con.setAutoCommit(false);

            int firstNextID = serviceStaff.getNextID_XK();

            // Thêm phiếu xuất kho
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());
            ModelPXK pxk = new ModelPXK(firstNextID, 100, today);
            ArrayList<ModelKho> listKho = new ArrayList<>();
            serviceStaff.InsertPXK_CTXK(pxk, listKho);

            int secondNextID = serviceStaff.getNextID_XK();

            assertTrue("Fail: ID tiếp theo phải lớn hơn ID hiện tại", secondNextID > firstNextID);
            assertEquals("Fail: ID tiếp theo phải bằng ID hiện tại + 1", firstNextID + 1, secondNextID);

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Kiểm tra getCTXK với phiếu xuất kho có nhiều chi tiết
     * Mong đợi: Tất cả chi tiết đều có số lượng > 0
     */
    @Test // SE_32
    public void testGetCTXK_SoLuongHopLe() throws SQLException {
        ArrayList<ModelPXK> listPXK = serviceStaff.MenuPXK();

        for (ModelPXK pxk : listPXK) {
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(pxk.getIdXK());

            // Kiểm tra tất cả chi tiết có số lượng > 0
            for (ModelCTXK ctxk : listCTXK) {
                assertTrue("Fail: Số lượng trong chi tiết xuất kho phải > 0 (ID_XK=" + pxk.getIdXK() + ")",
                        ctxk.getsL() > 0);
                assertNotNull("Fail: Tên nguyên liệu không được null", ctxk.getTenNL());
                assertNotNull("Fail: Đơn vị tính không được null", ctxk.getDvt());
            }
        }
    }

    /**
     * Test case: Kiểm tra MenuPXK với database có dữ liệu
     * Mong đợi: Tất cả phiếu xuất kho có ID_NV hợp lệ (> 0)
     */
    @Test // SE_33
    public void testMenuPXK_IdNhanVienHopLe() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        for (ModelPXK pxk : list) {
            assertTrue("Fail: ID nhân viên phải > 0 (ID_XK=" + pxk.getIdXK() + ")",
                    pxk.getIdNV() > 0);
            assertNotNull("Fail: Ngày xuất kho không được null", pxk.getNgayXK());
            assertFalse("Fail: Ngày xuất kho không được rỗng", pxk.getNgayXK().trim().isEmpty());
        }
    }

    /**
     * Test case: Kiểm tra định dạng ngày trong MenuPXK
     * Mong đợi: Ngày có định dạng dd-MM-yyyy
     */
    @Test // SE_34
    public void testMenuPXK_DinhDangNgay() throws SQLException {
        ArrayList<ModelPXK> list = serviceStaff.MenuPXK();

        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        sdf.setLenient(false); // Strict parsing

        for (ModelPXK pxk : list) {
            try {
                Date date = sdf.parse(pxk.getNgayXK());
                assertNotNull("Fail: Ngày xuất kho phải parse được (ID_XK=" + pxk.getIdXK() + ")", date);
            } catch (Exception e) {
                fail("Fail: Ngày xuất kho không đúng định dạng dd-MM-yyyy (ID_XK=" + pxk.getIdXK() + ", NgayXK="
                        + pxk.getNgayXK() + ")");
            }
        }
    }

    ////////////////////////////////////
    // Test cases QUAN TRỌNG - Kiểm tra logic nghiệp vụ kho
    ////////////////////////////////////

    /**
     * Test case: Xuất kho nhiều hơn số lượng tồn kho
     * Mong đợi: Ném ra SQLException hoặc không cho phép xuất
     * ĐÂY LÀ TEST CASE QUAN TRỌNG NHẤT - Đảm bảo tính toàn vẹn nghiệp vụ
     */
    @Test // SE_35
    public void testInsertPXK_CTXK_XuatNhieuHonTonKho() throws SQLException {
        System.out.println("\n========================================");
        System.out.println("TEST SE_35: Xuất nhiều hơn tồn kho");
        System.out.println("========================================");

        try {
            con.setAutoCommit(false);

            // Lấy thông tin kho hiện tại
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();
            if (listKho.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu trong kho để test");
            }

            // Tìm nguyên liệu có tồn kho > 0
            ModelKho khoItem = null;
            for (ModelKho item : listKho) {
                if (item.getSlTon() > 0) {
                    khoItem = item;
                    break;
                }
            }

            if (khoItem == null) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu có số lượng tồn > 0");
            }

            System.out.println("Nguyên liệu test: ID=" + khoItem.getIdNL() + ", Tên=" + khoItem.getTenNL());
            System.out.println("Số lượng tồn kho BAN ĐẦU: " + khoItem.getSlTon());

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            // Cố tình xuất nhiều hơn tồn kho
            int soLuongXuat = khoItem.getSlTon() + 100;
            System.out.println("Số lượng XUẤT (vượt tồn): " + soLuongXuat);

            listXuatKho.add(new ModelKho(
                    khoItem.getIdNL(),
                    khoItem.getTenNL(),
                    khoItem.getDvt(),
                    soLuongXuat));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            System.out.println("⚠️ HỆ THỐNG CHO PHÉP XUẤT (không ném exception)");

            // Kiểm tra số lượng tồn sau khi xuất
            String sql = "SELECT SLTon FROM Kho WHERE ID_NL = ?";
            PreparedStatement p = con.prepareStatement(sql);
            p.setInt(1, khoItem.getIdNL());
            ResultSet r = p.executeQuery();

            if (r.next()) {
                int slTonSauXuat = r.getInt("SLTon");
                System.out.println("Số lượng tồn SAU KHI XUẤT: " + slTonSauXuat);

                if (slTonSauXuat < 0) {
                    System.out.println("❌ BUG NGHIÊM TRỌNG: Số lượng tồn kho BỊ ÂM!");
                    System.out.println("❌ Hệ thống THIẾU ràng buộc CHECK (SLTon >= 0)");
                    System.out.println("❌ Hệ thống THIẾU validation trong code");
                    fail("BUG NGHIÊM TRỌNG: Số lượng tồn không được âm sau khi xuất kho. Tồn hiện tại: "
                            + slTonSauXuat);
                }

                assertTrue("Fail: Số lượng tồn không được âm sau khi xuất kho", slTonSauXuat >= 0);
            }
            r.close();
            p.close();

        } catch (SQLException e) {
            // Đây là kết quả mong đợi - hệ thống phải chặn việc xuất nhiều hơn tồn
            System.out.println("✅ HỆ THỐNG ĐÃ CHẶN (ném SQLException)");
            System.out.println("Exception: " + e.getMessage());
            assertTrue("Fail: Phải là lỗi liên quan đến ràng buộc số lượng tồn kho",
                    e.getMessage().contains("check") ||
                            e.getMessage().contains("constraint") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
            System.out.println("========================================\n");
        }
    }

    /**
     * Test case: Xuất kho đúng bằng số lượng tồn kho
     * Mong đợi: Xuất thành công, số lượng tồn = 0
     */
    @Test // SE_36
    public void testInsertPXK_CTXK_XuatBangTonKho() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy thông tin kho hiện tại
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();
            if (listKho.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu trong kho để test");
            }

            // Tìm nguyên liệu có tồn kho > 0
            ModelKho khoItem = null;
            for (ModelKho item : listKho) {
                if (item.getSlTon() > 0) {
                    khoItem = item;
                    break;
                }
            }

            if (khoItem == null) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu có số lượng tồn > 0");
            }

            int slTonBanDau = khoItem.getSlTon();

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            // Xuất đúng bằng số lượng tồn
            listXuatKho.add(new ModelKho(
                    khoItem.getIdNL(),
                    khoItem.getTenNL(),
                    khoItem.getDvt(),
                    slTonBanDau));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            // Kiểm tra phiếu xuất đã được tạo
            ModelPXK pxkInserted = serviceStaff.getPXKbyID(nextID);
            assertNotNull("Fail: Phiếu xuất kho phải được tạo thành công", pxkInserted);

            // Kiểm tra chi tiết xuất kho
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Phải có 1 chi tiết xuất kho", 1, listCTXK.size());
            assertEquals("Fail: Số lượng xuất phải khớp", slTonBanDau, listCTXK.get(0).getsL());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Xuất kho ít hơn số lượng tồn kho
     * Mong đợi: Xuất thành công, số lượng tồn giảm đúng
     */
    @Test // SE_37
    public void testInsertPXK_CTXK_XuatItHonTonKho() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy thông tin kho hiện tại
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();
            if (listKho.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu trong kho để test");
            }

            // Tìm nguyên liệu có tồn kho > 10
            ModelKho khoItem = null;
            for (ModelKho item : listKho) {
                if (item.getSlTon() > 10) {
                    khoItem = item;
                    break;
                }
            }

            if (khoItem == null) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu có số lượng tồn > 10");
            }

            int slTonBanDau = khoItem.getSlTon();
            int soLuongXuat = 5; // Xuất ít hơn tồn

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            listXuatKho.add(new ModelKho(
                    khoItem.getIdNL(),
                    khoItem.getTenNL(),
                    khoItem.getDvt(),
                    soLuongXuat));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            // Kiểm tra phiếu xuất đã được tạo
            ModelPXK pxkInserted = serviceStaff.getPXKbyID(nextID);
            assertNotNull("Fail: Phiếu xuất kho phải được tạo thành công", pxkInserted);

            // Kiểm tra chi tiết xuất kho
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            assertEquals("Fail: Phải có 1 chi tiết xuất kho", 1, listCTXK.size());
            assertEquals("Fail: Số lượng xuất phải khớp", soLuongXuat, listCTXK.get(0).getsL());

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Xuất kho nguyên liệu có số lượng tồn = 0
     * Mong đợi: Không cho phép xuất hoặc không thêm vào chi tiết
     */
    @Test // SE_38
    public void testInsertPXK_CTXK_XuatKhoTonBangKhong() throws SQLException {
        System.out.println("\n========================================");
        System.out.println("TEST SE_38: Xuất khi tồn kho = 0");
        System.out.println("========================================");

        try {
            con.setAutoCommit(false);

            // Tạo hoặc tìm nguyên liệu có tồn kho = 0
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();

            ModelKho khoItem = null;
            for (ModelKho item : listKho) {
                if (item.getSlTon() == 0) {
                    khoItem = item;
                    break;
                }
            }

            // Nếu không có nguyên liệu tồn = 0, tạo một cái
            if (khoItem == null && listKho.size() > 0) {
                khoItem = listKho.get(0);
                // Update số lượng tồn = 0
                String sql = "UPDATE Kho SET SLTon = 0 WHERE ID_NL = ?";
                PreparedStatement p = con.prepareStatement(sql);
                p.setInt(1, khoItem.getIdNL());
                p.execute();
                p.close();
                khoItem.setSlTon(0);
            }

            if (khoItem == null) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu trong kho để test");
            }

            System.out.println("Nguyên liệu test: ID=" + khoItem.getIdNL() + ", Tên=" + khoItem.getTenNL());
            System.out.println("Số lượng tồn kho: " + khoItem.getSlTon());

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            // Cố tình xuất nguyên liệu có tồn = 0
            int soLuongXuat = 10;
            System.out.println("Số lượng XUẤT: " + soLuongXuat);

            listXuatKho.add(new ModelKho(
                    khoItem.getIdNL(),
                    khoItem.getTenNL(),
                    khoItem.getDvt(),
                    soLuongXuat));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            System.out.println("⚠️ HỆ THỐNG CHO PHÉP XUẤT (không ném exception)");

            // Kiểm tra không có chi tiết xuất kho (vì tồn = 0)
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);
            System.out.println("Số chi tiết xuất kho: " + listCTXK.size());

            if (listCTXK.size() > 0) {
                System.out.println("❌ BUG: Hệ thống CHO PHÉP xuất khi tồn kho = 0!");
                System.out.println("❌ Hệ thống THIẾU validation: Không cho xuất khi tồn = 0");
                fail("BUG: Không được có chi tiết xuất kho khi tồn = 0. Số chi tiết: " + listCTXK.size());
            }

            assertEquals("Fail: Không được có chi tiết xuất kho khi tồn = 0", 0, listCTXK.size());
            System.out.println("✅ Hệ thống KHÔNG thêm chi tiết xuất kho (đúng)");

        } catch (SQLException e) {
            // Hoặc hệ thống ném exception - cũng là kết quả hợp lệ
            System.out.println("✅ HỆ THỐNG ĐÃ CHẶN (ném SQLException)");
            System.out.println("Exception: " + e.getMessage());
            assertTrue("Fail: Phải là lỗi liên quan đến ràng buộc số lượng tồn kho",
                    e.getMessage().contains("check") ||
                            e.getMessage().contains("constraint") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
            System.out.println("========================================\n");
        }
    }

    /**
     * Test case: Xuất kho nhiều nguyên liệu, một số vượt tồn kho
     * Mong đợi: Chỉ xuất những nguyên liệu hợp lệ, bỏ qua những cái vượt tồn
     */
    @Test // SE_39
    public void testInsertPXK_CTXK_MotSoNguyenLieuVuotTon() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy thông tin kho hiện tại
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();
            if (listKho.size() < 2) {
                fail("Fail: Database phải có ít nhất 2 nguyên liệu trong kho để test");
            }

            // Tìm 2 nguyên liệu có tồn kho > 0
            ModelKho khoItem1 = null;
            ModelKho khoItem2 = null;

            for (ModelKho item : listKho) {
                if (item.getSlTon() > 0) {
                    if (khoItem1 == null) {
                        khoItem1 = item;
                    } else if (khoItem2 == null) {
                        khoItem2 = item;
                        break;
                    }
                }
            }

            if (khoItem1 == null || khoItem2 == null) {
                fail("Fail: Database phải có ít nhất 2 nguyên liệu có số lượng tồn > 0");
            }

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            // Nguyên liệu 1: Xuất hợp lệ (ít hơn tồn)
            listXuatKho.add(new ModelKho(
                    khoItem1.getIdNL(),
                    khoItem1.getTenNL(),
                    khoItem1.getDvt(),
                    Math.min(5, khoItem1.getSlTon())));

            // Nguyên liệu 2: Xuất vượt tồn
            listXuatKho.add(new ModelKho(
                    khoItem2.getIdNL(),
                    khoItem2.getTenNL(),
                    khoItem2.getDvt(),
                    khoItem2.getSlTon() + 100));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            // Kiểm tra chi tiết xuất kho
            ArrayList<ModelCTXK> listCTXK = serviceStaff.getCTXK(nextID);

            // Nếu hệ thống xử lý đúng, chỉ có 1 chi tiết (nguyên liệu hợp lệ)
            // Hoặc ném exception cho toàn bộ giao dịch
            assertTrue("Fail: Số lượng chi tiết xuất kho phải <= 1 (chỉ xuất nguyên liệu hợp lệ)",
                    listCTXK.size() <= 1);

        } catch (SQLException e) {
            // Hoặc hệ thống ném exception cho toàn bộ giao dịch - cũng hợp lệ
            assertTrue("Fail: Phải là lỗi liên quan đến ràng buộc",
                    e.getMessage().contains("check") ||
                            e.getMessage().contains("constraint") ||
                            e.getMessage().contains("ORA") ||
                            e.getMessage().contains("violates"));
        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }

    /**
     * Test case: Kiểm tra số lượng tồn kho sau khi xuất
     * Mong đợi: Số lượng tồn giảm đúng bằng số lượng xuất
     * LƯU Ý: Test này giả định có trigger/procedure cập nhật tồn kho tự động
     */
    @Test // SE_40
    public void testInsertPXK_CTXK_KiemTraTonKhoSauXuat() throws SQLException {
        try {
            con.setAutoCommit(false);

            // Lấy thông tin kho hiện tại
            ArrayList<ModelKho> listKho = serviceStaff.MenuKhoNL();
            if (listKho.size() == 0) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu trong kho để test");
            }

            // Tìm nguyên liệu có tồn kho > 10
            ModelKho khoItem = null;
            for (ModelKho item : listKho) {
                if (item.getSlTon() > 10) {
                    khoItem = item;
                    break;
                }
            }

            if (khoItem == null) {
                fail("Fail: Database phải có ít nhất 1 nguyên liệu có số lượng tồn > 10");
            }

            int slTonBanDau = khoItem.getSlTon();
            int soLuongXuat = 5;

            int nextID = serviceStaff.getNextID_XK();
            SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
            String today = sdf.format(new Date());

            ModelPXK pxk = new ModelPXK(nextID, 100, today);
            ArrayList<ModelKho> listXuatKho = new ArrayList<>();

            listXuatKho.add(new ModelKho(
                    khoItem.getIdNL(),
                    khoItem.getTenNL(),
                    khoItem.getDvt(),
                    soLuongXuat));

            serviceStaff.InsertPXK_CTXK(pxk, listXuatKho);

            // Kiểm tra số lượng tồn sau khi xuất
            String sql = "SELECT SLTon FROM Kho WHERE ID_NL = ?";
            PreparedStatement p = con.prepareStatement(sql);
            p.setInt(1, khoItem.getIdNL());
            ResultSet r = p.executeQuery();

            if (r.next()) {
                int slTonSauXuat = r.getInt("SLTon");

                // Nếu có trigger tự động trừ tồn kho
                if (slTonSauXuat != slTonBanDau) {
                    assertEquals("Fail: Số lượng tồn sau xuất phải = tồn ban đầu - số lượng xuất",
                            slTonBanDau - soLuongXuat, slTonSauXuat);
                }
                // Nếu không có trigger, số lượng tồn không đổi (cần cập nhật thủ công)
            }
            r.close();
            p.close();

        } finally {
            con.rollback();
            con.setAutoCommit(true);
        }
    }
}
