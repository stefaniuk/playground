package io.codeworks.commons.test;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

import javax.sql.DataSource;

import org.hibernate.SessionFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.orm.hibernate4.HibernateTransactionManager;
import org.springframework.orm.hibernate4.LocalSessionFactoryBean;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jolbox.bonecp.BoneCPDataSource;

@Configuration
@ComponentScan("io.codeworks.commons.test")
@EnableWebMvc
@EnableTransactionManagement
public class Config extends WebMvcConfigurerAdapter {

    @Override
    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {

        configurer
            .favorPathExtension(false)
            .favorParameter(true)
            .parameterName("mediaType")
            .ignoreAcceptHeader(true)
            .useJaf(false)
            .defaultContentType(MediaType.APPLICATION_JSON)
            .mediaType("json", MediaType.APPLICATION_JSON);
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {

        MappingJackson2HttpMessageConverter bean = new MappingJackson2HttpMessageConverter();

        bean.setObjectMapper(new ObjectMapper());

        converters.add(bean);
    }

    @Bean(destroyMethod = "close")
    public DataSource dataSource() {

        BoneCPDataSource bean = new BoneCPDataSource();

        bean.setDriverClass("org.h2.Driver");
        bean.setJdbcUrl("jdbc:h2:mem:test");
        bean.setUsername("");
        bean.setPassword("");
        bean.setMinConnectionsPerPartition(5);
        bean.setMaxConnectionsPerPartition(15);
        bean.setMaxConnectionAgeInSeconds(60);
        bean.setPartitionCount(3);

        return bean;
    }

    @Bean
    public SessionFactory sessionFactory() throws IOException {

        Properties hibernateProps = new Properties();

        hibernateProps.setProperty("hibernate.dialect", "org.hibernate.dialect.H2Dialect");
        hibernateProps.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.internal.NoCacheProvider");
        hibernateProps.setProperty("hibernate.show_sql", "false");
        hibernateProps.setProperty("hibernate.hbm2ddl.auto", "create");
        hibernateProps.setProperty("hibernate.connection.release_mode", "after_transaction");

        LocalSessionFactoryBean bean = new LocalSessionFactoryBean();

        bean.setDataSource(dataSource());
        bean.setPackagesToScan("io.codeworks.commons.test");
        bean.setHibernateProperties(hibernateProps);
        bean.afterPropertiesSet();

        return bean.getObject();
    }

    @Bean
    public PlatformTransactionManager transactionManager() throws IOException {

        HibernateTransactionManager bean = new HibernateTransactionManager();

        bean.setDataSource(dataSource());
        bean.setSessionFactory(sessionFactory());

        return bean;
    }

}
