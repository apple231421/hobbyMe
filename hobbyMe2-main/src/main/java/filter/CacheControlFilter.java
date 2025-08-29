package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletResponse;

public class CacheControlFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // HttpServletResponse로 캐스팅
        HttpServletResponse httpResp = (HttpServletResponse) response;

        // 캐시 방지 설정
        httpResp.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        httpResp.setHeader("Pragma", "no-cache");
        httpResp.setDateHeader("Expires", 0);

        // 다음 필터 또는 서블릿으로 요청 전달
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 종료 시 정리할 리소스 없음
    }
}
