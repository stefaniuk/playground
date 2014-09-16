package io.codeworks.archetypes.api.test;

import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.Database;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import com.jolbox.bonecp.BoneCPDataSource;

@Configuration
@ComponentScan
@EnableJpaRepositories
@EnableTransactionManagement
public class TestConfig {

    @Bean(destroyMethod = "close")
    public DataSource dataSource() {

        BoneCPDataSource ds = new BoneCPDataSource();

        ds.setDriverClass("org.h2.Driver");
        ds.setJdbcUrl("jdbc:h2:mem:test");
        ds.setUsername("");
        ds.setPassword("");
        ds.setMinConnectionsPerPartition(5);
        ds.setMaxConnectionsPerPartition(15);
        ds.setMaxConnectionAgeInSeconds(60);
        ds.setPartitionCount(3);

        return ds;
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {

        HibernateJpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
        adapter.setDatabase(Database.H2);

        Properties properties = new Properties();
        properties.setProperty("hibernate.hbm2ddl.auto", "create");
        properties.setProperty("hibernate.show_sql", "true");
        properties.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.NoCacheProvider");
        properties.setProperty("hibernate.connection.release_mode", "after_transaction");

        LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();

        factory.setDataSource(dataSource());
        factory.setPackagesToScan(getClass().getPackage().getName());
        factory.setJpaVendorAdapter(adapter);
        factory.setJpaProperties(properties);
        factory.afterPropertiesSet();

        return factory;
    }

    @Bean
    public PlatformTransactionManager transactionManager() {

        JpaTransactionManager tm = new JpaTransactionManager();

        tm.setEntityManagerFactory(entityManagerFactory().getObject());

        return tm;
    }

}
