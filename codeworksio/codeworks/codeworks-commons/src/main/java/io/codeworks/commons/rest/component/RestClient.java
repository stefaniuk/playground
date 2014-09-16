package io.codeworks.commons.rest.component;

import io.codeworks.commons.commons.exception.CodeworksException;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.GenericTypeResolver;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class RestClient<T> {

    // TODO: This class needs to be rewritten.

    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired(required = false)
    private RestTemplate restTemplate;

    private Class<T> clazz;

    private String className;

    private String url;

    public RestTemplate getRestTemplate() {

        return restTemplate;
    }

    public void setRestTemplate(RestTemplate restTemplate) {

        this.restTemplate = restTemplate;
    }

    public Class<T> getClazz() {

        return clazz;
    }

    public String getClassName() {

        return className;
    }

    public String getUrl() {

        return url;
    }

    @SuppressWarnings("unchecked")
    public RestClient(String url) {

        this.clazz = (Class<T>) GenericTypeResolver.resolveTypeArgument(getClass(), RestClient.class);
        this.className = clazz.getName();
        this.url = url;
    }

    public T searchUnique(T criteria, ParameterizedTypeReference<List<T>> typeRef) {

        logger.debug("rest search unique call to " + url);

        List<T> list = search(criteria, typeRef);
        if(list.size() == 0) {
            return null;
        }
        else if(list.size() == 1) {
            return list.get(0);
        }
        else {
            throw new CodeworksException("Only one record expected for the following criteria " + criteria);
        }
    }

    public List<T> search(T criteria, ParameterizedTypeReference<List<T>> typeRef) {

        logger.debug("search api call to " + url);

        ResponseEntity<List<T>> response = restTemplate.exchange(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s/search",
            HttpMethod.POST,
            new HttpEntity<T>(criteria),
            typeRef);
        List<T> list = response.getBody();

        return list;
    }

    public List<T> read(ParameterizedTypeReference<List<T>> typeRef) {

        logger.debug("read all api call to " + url);

        ResponseEntity<List<T>> response = restTemplate.exchange(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s",
            HttpMethod.GET,
            null,
            typeRef);
        List<T> list = response.getBody();

        return list;
    }

    public List<T> read(String path, ParameterizedTypeReference<List<T>> typeRef) {

        logger.debug("read all api call to " + url);

        ResponseEntity<List<T>> response = restTemplate.exchange(
            url + path,
            HttpMethod.GET,
            null,
            typeRef);
        List<T> list = response.getBody();

        return list;
    }

    public T read(Integer id, Class<T> clazz) {

        logger.debug("read by id api call to " + url);

        T object = null;
        object = restTemplate.getForObject(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s/{id}",
            clazz,
            id);

        return object;
    }

    public T read(Integer id, Class<T> clazz, String path) {

        logger.debug("read by id api call to " + url);

        T object = null;
        object = restTemplate.getForObject(
            url + path,
            clazz,
            id);

        return object;
    }

    public T create(T model, Class<T> clazz) {

        logger.debug("create api call to " + url);

        T object = null;
        object = restTemplate.postForObject(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s",
            model,
            clazz);

        return object;
    }

    public T update(Integer id, T model, Class<T> clazz) {

        logger.debug("update api call to " + url);

        T object = null;
        object = restTemplate.postForObject(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s/" + id,
            model,
            clazz);

        return object;
    }

    public T delete(Integer id, Class<T> clazz) {

        logger.debug("delete api call to " + url);

        T object = null;
        object = restTemplate.getForObject(
            url + "/" + clazz.getSimpleName().toLowerCase() + "s/{id}",
            clazz,
            id);
        restTemplate.delete(url + "/" + clazz.getSimpleName().toLowerCase() + "s/" + id);

        return object;
    }

}
