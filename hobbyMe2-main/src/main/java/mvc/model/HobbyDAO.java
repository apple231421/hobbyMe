package mvc.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import mvc.database.DBConnection;


public class HobbyDAO {

	private static HobbyDAO instance;

	private HobbyDAO() {

	}

	public static HobbyDAO getInstance() {
		if (instance == null)
			instance = new HobbyDAO();
		return instance;
	}

	public boolean validateUser(String id, String password) {
		boolean isValid = false;
		String sql = "SELECT * FROM user WHERE user_id=? AND password=? AND deleted = 'N'";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, id);
			pstmt.setString(2, password);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					isValid = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return isValid;
	}

	public HobbyDTO getUserById(String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HobbyDTO user = null;

		String sql = "SELECT * FROM user WHERE user_id = ? AND deleted = 'N'";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				user = new HobbyDTO();
				user.setUserId(rs.getString("user_id"));
				user.setPassword(rs.getString("password"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setPhone(rs.getString("phone"));
				user.setAddress(rs.getString("address"));
				user.setGender(rs.getString("gender"));
				user.setBirthdate(rs.getDate("birthdate"));
				user.setClasses(rs.getString("classes"));
				user.setDeleted(rs.getString("deleted"));
			}
		} catch (Exception e) {
			System.out.println("getUserById() : " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		}
		return user;
	}

	public void insertUser(HobbyDTO user) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = DBConnection.getConnection();

			String sql = "insert into user(user_id,password,name,email,phone,address,gender,birthdate,classes,deleted)"
					+ "values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getName());
			pstmt.setString(4, user.getEmail());
			pstmt.setString(5, user.getPhone());
			pstmt.setString(6, user.getAddress());
			pstmt.setString(7, user.getGender());
			pstmt.setDate(8, user.getBirthdate());
			pstmt.setString(9, user.getClasses());
			pstmt.setString(10, "N");

			pstmt.executeUpdate();
		} catch (Exception ex) {
			System.out.println("insertUser()      : " + ex);
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception ex) {
				throw new RuntimeException(ex.getMessage());
			}
		}
	}
	public void updateUser(HobbyDTO dto) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "UPDATE user SET phone = ?, address = ?, gender = ?, birthdate = ? WHERE user_id = ? AND deleted = 'N'";

	    try {
	        conn = DBConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, dto.getPhone());
	        pstmt.setString(2, dto.getAddress());
	        pstmt.setString(3, dto.getGender());
	        pstmt.setDate(4, dto.getBirthdate());
	        pstmt.setString(5, dto.getUserId());

	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public String findUserIdByNameAndEmail(String name, String email) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
		String userId = null;
	    String sql = "SELECT user_id FROM user WHERE name = ? AND email = ? AND deleted = 'N'";

	    try {
	    	conn = DBConnection.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, name);
	        pstmt.setString(2, email);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            userId = rs.getString("user_id");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return userId;
	}

	public boolean checkUserIdAndEmail(String userId, String email) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "SELECT user_id FROM user WHERE user_id = ? AND email = ? AND deleted = 'N'";

	    try {
	    	conn = DBConnection.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, email);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            return true;
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

		return false;
	}

	public void saveResetToken(String userId, String token) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
		String sql = "INSERT INTO UserToken (user_id, token, expires_at,token_type) VALUES (?, ?, ?, ?)";

	    try {
	    	conn = DBConnection.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, token);
	        // 만료시간: 현재시간 + 30분
	        LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(30);
	        pstmt.setTimestamp(3, Timestamp.valueOf(expiryTime));
	        pstmt.setString(4, "reset");
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public String getUserIdByToken(String token) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    String userId = null;
	    String sql = "SELECT b.user_id "
	    		+ "FROM usertoken a "
	    		+ "INNER JOIN user b ON a.user_id = b.user_id "
	    		+ "WHERE a.token = ? AND b.deleted = 'N' AND a.is_revoked = 'N'";
	    try {
	    	conn = DBConnection.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, token);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            return userId = rs.getString("user_id");
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userId;
	}

	public void updatePassword(String userId, String pw1) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "UPDATE user SET password = ? WHERE user_id = ? AND deleted = 'N'";
	    
	    try {
	    	conn = DBConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, pw1);
	        pstmt.setString(2, userId);

	        pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void deleteToken(String userId) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "UPDATE usertoken SET is_revoked = 'Y' WHERE user_id = ?";
	    
	    try {
	    	conn = DBConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public HobbyDTO getUserByEmail(String email) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HobbyDTO user = null;

		String sql = "SELECT email,user_id FROM user WHERE email = ? AND deleted = 'N'";

		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				user = new HobbyDTO();
				user.setUserId(rs.getString("user_id"));
				user.setEmail(rs.getString("email"));
			}
		} catch (Exception e) {
			System.out.println("getUserByEmail() : " + e);
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage());
			}
		}
		return user;
	}
	
	public void insertApply(HobbyDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "INSERT INTO host (user_id, user_grade, host_state, host_title, host_content, host_file, host_active) VALUES (?,?,?,?,?,?,?)";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUserId());
			pstmt.setString(2, dto.getClasses());
			pstmt.setString(3, "H");
			pstmt.setString(4, dto.getHostTitle());
			pstmt.setString(5, dto.getHostContent());
			pstmt.setString(6, dto.getHostFile());
			pstmt.setString(7, "N");
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public Boolean checkApply(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "SELECT * FROM host WHERE user_id = ? AND user_grade = 'H' AND host_state = 'G' AND host_active = 'Y'";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) {
	            return true;
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public HobbyDTO getApplyById(String id,int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		HobbyDTO user = null;
		String sql;
		try {
			if(num != 0) {
				sql = "SELECT * FROM host WHERE user_id = ? AND host_num = ?";
			} else {
				sql = "SELECT * FROM host WHERE user_id = ? AND user_grade = 'H' AND host_state = 'G' AND host_active = 'Y'";
			}
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			if(num != 0) {
				pstmt.setInt(2, num);
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user = new HobbyDTO();
				user.setUserId(rs.getString("user_id"));
				user.setHostTitle(rs.getString("host_title"));
				user.setHostContent(rs.getString("host_content"));
				user.setHostFile(rs.getString("host_file"));
				user.setGrade(rs.getString("user_grade"));
				user.setHostState(rs.getString("host_state"));
				return user;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	
	public int getListCount(String items, String text) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;

      int x = 0;

      String sql;
      
      if (items == null && text == null)
         sql = "select  count(*) from host";
      else
         sql = "SELECT   count(*) FROM host where " + items + " like '%" + text + "%'";
      
      try {
         conn = DBConnection.getConnection();
         pstmt = conn.prepareStatement(sql);
         rs = pstmt.executeQuery();

         if (rs.next()) 
            x = rs.getInt(1);
         
      } catch (Exception ex) {
         System.out.println("getListCount()     : " + ex);
      } finally {         
         try {            
            if (rs != null) 
               rs.close();                     
            if (pstmt != null) 
               pstmt.close();            
            if (conn != null) 
               conn.close();                                    
         } catch (Exception ex) {
            throw new RuntimeException(ex.getMessage());
         }      
      }      
      return x;
	}
	public ArrayList<HobbyDTO> getApplyList(int page, int limit, String items, String text) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int total_record = getListCount(items, text );
	      int start = (page - 1) * limit;
	      int index = start + 1;

	      String sql;

	      if (items == null && text == null)
	         sql = "select * from host ORDER BY host_num DESC";
	      else
	         sql = "SELECT  * FROM host where " + items + " like '%" + text + "%' ORDER BY host_num DESC ";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         
	         
	         pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	         rs = pstmt.executeQuery();
	         
	         while (rs.absolute(index)) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setUserNum(rs.getInt("host_num"));
	            apply.setUserId(rs.getString("user_id"));
	            apply.setHostTitle(rs.getString("host_title"));
	            apply.setHostContent(rs.getString("host_content"));
	            apply.setHostState(rs.getString("host_state"));
	            apply.setGrade(rs.getString("user_grade"));
	            list.add(apply);
	            
	            if (index < (start + limit) && index <= total_record)
	               index++;
	            else
	               break;
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getApplyList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}

	public void approveHost(String id, int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "UPDATE host SET host_state = 'G', user_grade = 'H', host_active = 'Y' WHERE user_id = ? AND host_num = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			pstmt.executeUpdate();
			sql = "UPDATE user SET classes = 'H' WHERE user_id = ?";
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void rejectHost(String id, int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "UPDATE host SET host_state = 'R', host_active = 'N', user_grade = 'U' WHERE user_id = ? AND host_num = ?";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			pstmt.executeUpdate();
			sql = "UPDATE user SET classes = 'U' WHERE user_id = ?";
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void insertCategory(String name) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "INSERT INTO category (category_name) VALUES (?)";
	    try {
	    	conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, name);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	public List<HobbyDTO> getAllCategories() {
	    List<HobbyDTO> list = new ArrayList<>();
	    Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
	    String sql = "SELECT * FROM category WHERE deleted = 'N' ORDER BY category_num ASC";
	    try {
	    	conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
	    	while (rs.next()) {
	        	HobbyDTO dto = new HobbyDTO();
	            dto.setCategoryNum(rs.getInt("category_num"));
	            dto.setCategoryName(rs.getString("category_name"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}

	public void deleteCategory(int id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "UPDATE category SET deleted = 'Y' WHERE category_num = ?";
	    try {
	    	conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, id);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public void deleteMemberById(String sessionId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "UPDATE user SET deleted = 'Y' WHERE user_id = ?";
	    try {
	    	conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
	    	pstmt.setString(1, sessionId);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public ArrayList<HobbyDTO> getMyBoardList(String id) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT * FROM post WHERE user_id = ? AND deleted = 'N' ORDER BY post_num DESC";

	    ArrayList<HobbyDTO> list = new ArrayList<>();

	    try {
	        conn = DBConnection.getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, id);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyBoardNum(rs.getInt("post_num"));
	            apply.setMyBoardTitle(rs.getString("title"));
	            apply.setMyBoardPrice(rs.getInt("price"));
	            apply.setMyBoardReservation(rs.getString("reservation_date"));
	            apply.setMyBoardEndDate(rs.getString("end_date"));
	            apply.setMyId(rs.getString("user_id"));
	            apply.setMyBoardState(rs.getString("deleted"));
	            list.add(apply);
	        }
	        return list;
	    } catch (Exception ex) {
	        System.out.println("getMyList() : " + ex);
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.close();
	        } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	        }
	    }
	    return null;
	}

	public ArrayList<HobbyDTO> getMyPaymentList(String id) {
		Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      String sql = "select * from payment where user_id = ? AND deleted = 'N'  ORDER BY payment_id DESC";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setString(1, id);
	         rs = pstmt.executeQuery();
	         
	         while (rs.next()) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyPayNum(rs.getInt("post_num"));
	            apply.setMyPayTitle(rs.getString("title"));
	            apply.setMyPayReservation(rs.getString("reservation_date"));
	            apply.setMyPayEndDate(rs.getString("end_date"));
	            apply.setMyId(rs.getString("user_id"));
	            apply.setMyPayState(rs.getString("state"));
	            list.add(apply);
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getMyPaymentList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}
	
	public int getPaymentListCount(String items, String text) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int x = 0;

	      String sql;
	      
	      if (items == null && text == null)
	         sql = "select  count(*) from payment";
	      else
	         sql = "SELECT   count(*) FROM payment where " + items + " like '%" + text + "%'";
	      
	      try {
	         conn = DBConnection.getConnection();
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();

	         if (rs.next()) 
	            x = rs.getInt(1);
	         
	      } catch (Exception ex) {
	         System.out.println("getPaymentListCount()     : " + ex);
	      } finally {         
	         try {            
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();                                    
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }      
	      }      
	      return x;
		}
	
	public ArrayList<HobbyDTO> getPaymentList(int page, int limit, String items, String text) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int total_record = getPaymentListCount(items, text );
	      int start = (page - 1) * limit;
	      int index = start + 1;

	      String sql;

	      if (items == null && text == null)
	         sql = "select * from payment ORDER BY payment_id DESC";
	      else
	         sql = "SELECT  * FROM payment where " + items + " like '%" + text + "%' ORDER BY payment_id DESC ";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         
	         
	         pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	         rs = pstmt.executeQuery();
	         
	         while (rs.absolute(index)) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyId(rs.getString("user_id"));
	            apply.setMyPayNum(rs.getInt("payment_id"));
	            apply.setMyPayTitle(rs.getString("title"));
	            apply.setMyPayReservation(rs.getString("reservation_date"));
	            apply.setMyPayEndDate(rs.getString("end_date"));
	            apply.setMyPayState(rs.getString("state"));
	            apply.setMyBoardPrice(rs.getInt("price"));
	            apply.setMyBoardNum(rs.getInt("post_num"));
	            list.add(apply);
	            
	            if (index < (start + limit) && index <= total_record)
	               index++;
	            else
	               break;
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getPaymentList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}

	public int getMyPayListCount(String items, String text, String id) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int x = 0;

	    String sql;
	      
	    if (items == null && text == null)
	       sql = "select  count(*) from payment where user_id = ? AND deleted = 'N'";
	    else
	       sql = "SELECT   count(*) FROM payment where " + items + " like '%" + text + "%' AND user_id = ? AND deleted = 'N'";
	      
	    try {
	       conn = DBConnection.getConnection();
	       pstmt = conn.prepareStatement(sql);
	       pstmt.setString(1, id);
	       rs = pstmt.executeQuery();

	       if (rs.next()) 
	          x = rs.getInt(1);
	         
	    } catch (Exception ex) {
	       System.out.println("getMyPayListCount()     : " + ex);
	    } finally {         
	       try {            
	          if (rs != null) 
	             rs.close();                     
	          if (pstmt != null) 
	             pstmt.close();            
	          if (conn != null) 
	             conn.close();                                    
	       } catch (Exception ex) {
	          throw new RuntimeException(ex.getMessage());
	       }      
	    }      
	      return x;
	}

	public ArrayList<HobbyDTO> getMyPayList(int page, int limit, String items, String text , String id) {
		Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int total_record = getMyPayListCount(items, text, id);
	      int start = (page - 1) * limit;
	      int index = start + 1;

	      String sql;

	      if (items == null && text == null)
	         sql = "select * from payment Where user_id = ? AND deleted = 'N' ORDER BY payment_id DESC";
	      else
	         sql = "SELECT  * FROM payment where " + items + " like '%" + text + "%' AND user_id = ? AND deleted = 'N' ORDER BY payment_id DESC ";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         
	         
	         pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	         pstmt.setString(1, id);
	         rs = pstmt.executeQuery();
	         
	         while (rs.absolute(index)) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyId(rs.getString("user_id"));
	            apply.setMyPayNum(rs.getInt("payment_id"));
	            apply.setMyPayTitle(rs.getString("title"));
	            apply.setMyPayReservation(rs.getString("reservation_date"));
	            apply.setMyPayEndDate(rs.getString("end_date"));
	            apply.setMyPayState(rs.getString("state"));
	            apply.setMyBoardPrice(rs.getInt("price"));
	            apply.setMyBoardNum(rs.getInt("post_num"));
	            list.add(apply);
	            
	            if (index < (start + limit) && index <= total_record)
	               index++;
	            else
	               break;
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getMyPayList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}
	
	public int getMyCouponListCount(String items, String text, String id) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    int x = 0;

	    String sql;
	      
	    if (items == null && text == null)
	       sql = "select  count(*) from coupon where user_id = ? AND coupon_deleted = 'N'";
	    else
	       sql = "SELECT   count(*) FROM coupon where " + items + " like '%" + text + "%' AND user_id = ? AND coupon_deleted = 'N'";
	      
	    try {
	       conn = DBConnection.getConnection();
	       pstmt = conn.prepareStatement(sql);
	       pstmt.setString(1, id);
	       rs = pstmt.executeQuery();

	       if (rs.next()) 
	          x = rs.getInt(1);
	         
	    } catch (Exception ex) {
	       System.out.println("getMyCouponListCount()     : " + ex);
	    } finally {         
	       try {            
	          if (rs != null) 
	             rs.close();                     
	          if (pstmt != null) 
	             pstmt.close();            
	          if (conn != null) 
	             conn.close();                                    
	       } catch (Exception ex) {
	          throw new RuntimeException(ex.getMessage());
	       }      
	    }      
	      return x;
	}
	
	public ArrayList<HobbyDTO> getMyCouponList(int page, int limit, String items, String text , String id) {
		Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int total_record = getMyCouponListCount(items, text, id);
	      int start = (page - 1) * limit;
	      int index = start + 1;

	      String sql;

	      if (items == null && text == null)
	         sql = "select * from coupon Where user_id = ? AND coupon_deleted = 'N' ORDER BY coupon_num DESC";
	      else
	         sql = "SELECT  * FROM coupon where " + items + " like '%" + text + "%' AND user_id = ? AND coupon_deleted = 'N' ORDER BY coupon_num DESC ";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         
	         
	         pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	         pstmt.setString(1, id);
	         rs = pstmt.executeQuery();
	         
	         while (rs.absolute(index)) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyId(rs.getString("user_id"));
	            apply.setCouponNum(rs.getInt("coupon_num"));
	            apply.setCouponContent(rs.getString("coupon_content"));
	            apply.setCouponState(rs.getString("coupon_state"));
	            apply.setCouponStart(rs.getString("start_date"));
	            apply.setCouponEnd(rs.getString("end_date"));
	            apply.setCouponValue(rs.getInt("coupon_value"));
	            apply.setCouponDel(rs.getString("coupon_deleted"));
	            apply.setCouponType(rs.getString("coupon_type"));
	            list.add(apply);
	            
	            if (index < (start + limit) && index <= total_record)
	               index++;
	            else
	               break;
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getMyCouponList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}
	
	public int getCouponListCount(String items, String text) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int x = 0;

	      String sql;
	      
	      if (items == null && text == null)
	         sql = "select  count(*) from coupon WHERE coupon_deleted = 'N'";
	      else
	         sql = "SELECT   count(*) FROM coupon where " + items + " like '%" + text + "%' AND coupon_deleted = 'N'";
	      
	      try {
	         conn = DBConnection.getConnection();
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();

	         if (rs.next()) 
	            x = rs.getInt(1);
	         
	      } catch (Exception ex) {
	         System.out.println("getCouponListCount()     : " + ex);
	      } finally {         
	         try {            
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();                                    
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }      
	      }      
	      return x;
	}
	
	public ArrayList<HobbyDTO> getCouponList(int page, int limit, String items, String text) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;

	      int total_record = getCouponListCount(items, text );
	      int start = (page - 1) * limit;
	      int index = start + 1;

	      String sql;

	      if (items == null && text == null)
	         sql = "select * from coupon WHERE coupon_deleted = 'N' ORDER BY coupon_num DESC";
	      else
	         sql = "SELECT  * FROM coupon where " + items + " like '%" + text + "%' AND coupon_deleted = 'N' ORDER BY coupon_num DESC ";

	      ArrayList<HobbyDTO> list = new ArrayList<HobbyDTO>();
	   
	      try {
	         conn = DBConnection.getConnection();
	         pstmt = conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
	         rs = pstmt.executeQuery();
	         
	         while (rs.absolute(index)) {
	            HobbyDTO apply = new HobbyDTO();
	            apply.setMyId(rs.getString("user_id"));
	            apply.setCouponNum(rs.getInt("coupon_num"));
	            apply.setCouponContent(rs.getString("coupon_content"));
	            apply.setCouponState(rs.getString("coupon_state"));
	            apply.setCouponStart(rs.getString("start_date"));
	            apply.setCouponEnd(rs.getString("end_date"));
	            apply.setCouponValue(rs.getInt("coupon_value"));
	            apply.setCouponDel(rs.getString("coupon_deleted"));
	            apply.setCouponType(rs.getString("coupon_type"));
	            list.add(apply);
	            
	            if (index < (start + limit) && index <= total_record)
	               index++;
	            else
	               break;
	         }
	         return list;
	      } catch (Exception ex) {
	         System.out.println("getCouponList()      : " + ex);
	      } finally {
	         try {
	            if (rs != null) 
	               rs.close();                     
	            if (pstmt != null) 
	               pstmt.close();            
	            if (conn != null) 
	               conn.close();
	         } catch (Exception ex) {
	            throw new RuntimeException(ex.getMessage());
	         }         
	      }
	      return null;
	}

	public static void deleteCouponById(int id) {
		Connection conn = null;
	    PreparedStatement pstmt = null;
		String sql = "UPDATE coupon SET coupon_deleted = 'Y', coupon_state = 'E' WHERE coupon_num = ?";
	    try {
	    	conn = DBConnection.getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, id);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
	public Boolean checkApplyed(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "SELECT * FROM host WHERE user_id = ? AND user_grade = 'U' AND host_state = 'H' AND host_active = 'N'";
		try {
			conn = DBConnection.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			ResultSet rs = pstmt.executeQuery();
			
			if (rs.next()) {
	            return true;
	        }
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
