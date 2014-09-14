package org.stefaniuk.args4j.test.parameter;

import java.util.List;
import java.util.Map;

import org.stefaniuk.args4j.annotation.Option;
import org.stefaniuk.args4j.handler.JSONHandler;
import org.stefaniuk.args4j.test.bean.Json;

import com.fasterxml.jackson.databind.JsonNode;

public class JSONParameters {

    @Option(name = "/json1", handler = JSONHandler.class)
    private JsonNode json1;

    @Option(name = "/json2", handler = JSONHandler.class)
    private JsonNode json2;

    @Option(name = "/json3", handler = JSONHandler.class)
    private Map<?, ?> json3;

    @Option(name = "/json4", handler = JSONHandler.class)
    private List<?> json4;

    @Option(name = "/json5", handler = JSONHandler.class)
    private Json json5;

    public JsonNode getJson1() {

        return json1;
    }

    public JsonNode getJson2() {

        return json2;
    }

    public Map<?, ?> getJson3() {

        return json3;
    }

    public List<?> getJson4() {

        return json4;
    }

    public Json getJson5() {

        return json5;
    }

}
