import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.PickupDAO;

@WebServlet("/pickup")
public class Pickup extends HttpServlet{
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8"); //요청 관련 인코딩 처리
		response.setContentType("text/html;charset=utf-8"); //응답 관련 인코딩 처리
		
		PickupDAO dao = new PickupDAO();
		dao.pickupList(request, response);
		
		RequestDispatcher rd = request.getRequestDispatcher("./pickup.jsp");
		rd.forward(request, response);
		
	}
}
