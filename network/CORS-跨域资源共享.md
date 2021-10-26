# CORS-跨域资源共享

CORS 全称：Cross-Origin Resource Sharing ，中文名：跨域资源共享，简称”跨域“。

允许浏览器向Origin的服务器发起JavaScript请求获取响应。

实现跨域的几种形式：

- Jsonp，如：JQuery，Vue

- Nginx（见《Nginx 跨域》笔记）

- 后端程序配置，如SpringBoot Cors、.NET Core Cors等。

  SpringBoot Cors：

  ```java
  @Configuration
  public class CorsConfig {
      public CorsConfig() {  }
      @Bean
      public CorsFilter corsFilter() {
          // 1. 添加cors配置信息
          CorsConfiguration config = new CorsConfiguration();
          // config.addAllowedOrigin("http://localhost:8080");
          config.addAllowedOrigin("*");
          // 设置是否发送cookie信息
          config.setAllowCredentials(true);
          // 设置允许请求的方式
          config.addAllowedMethod("*");
          // 设置允许的header
          config.addAllowedHeader("*");
          // 2. 为url添加映射路径
          UrlBasedCorsConfigurationSource corsSource = new UrlBasedCorsConfigurationSource();
          corsSource.registerCorsConfiguration("/**", config);
          // 3. 返回重新定义好的corsSource
          return new CorsFilter(corsSource);
      }
  }
  ```

  

