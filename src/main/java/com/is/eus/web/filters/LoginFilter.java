 package com.is.eus.web.filters;

 import java.io.IOException;
 import java.util.HashSet;
 import javax.servlet.Filter;
 import javax.servlet.FilterChain;
 import javax.servlet.FilterConfig;
 import javax.servlet.ServletContext;
 import javax.servlet.ServletException;
 import javax.servlet.ServletRequest;
 import javax.servlet.ServletResponse;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;
 import javax.servlet.http.HttpSession;
 import org.apache.log4j.Logger;

 public class LoginFilter
   implements Filter
 {
   private static final Logger log = Logger.getLogger(LoginFilter.class);
   protected static final String SESSION_USERID = "user";
   private String loginPageURI;
   ServletContext servletContext;
   HashSet<String> excludedPages = new HashSet();
   HashSet<String> excludedPrefixes = new HashSet();

   public void destroy()
   {
   }

   public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
     throws IOException, ServletException
   {
     HttpServletRequest httpRequest = (HttpServletRequest)request;
     String contextPath = httpRequest.getContextPath();
     String destinUrl = httpRequest.getServletPath();
     if ((alreadyLogon(httpRequest)) || (excluded(destinUrl))) {
       chain.doFilter(request, response);
     } else {
       log.info("Login Filting Dest:" + destinUrl);
       HttpServletResponse httpResponse = (HttpServletResponse)response;
       String redirectPage = httpResponse.encodeRedirectURL(contextPath + this.loginPageURI);
       httpResponse.sendRedirect(redirectPage);
     }
   }

   private boolean alreadyLogon(HttpServletRequest request)
   {
     HttpSession session = request.getSession(false);
     if (session == null) {
       return false;
     }

     return session.getAttribute("user") != null;
   }

   private boolean excluded(String url)
   {
     if (this.excludedPages.contains(url)) {
       return true;
     }

     for (String prefix : this.excludedPrefixes) {
       if (url.startsWith(prefix)) {
         return true;
       }
     }
     return false;
   }

   public void init(FilterConfig config) throws ServletException
   {
     this.loginPageURI = config.getInitParameter("LoginPage");
     String excludes = config.getInitParameter("excludes");
     for (String path : excludes.split(",")) {
       if (path.endsWith("*"))
         this.excludedPrefixes.add(path.substring(0, path.length() - 1));
       else {
         this.excludedPages.add(path);
       }
     }
     this.servletContext = config.getServletContext();
   }
 }

