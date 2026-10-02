# Jackson 2.x migration to Jackson 3.x

## Overview

This migration ensures that serialization, deserialization, and schema validation behaviour remain reliable after moving from Jackson 2 style usage to the Jackson 3 aligned stack used in your upgraded baseline. This phase is not only an import migration, it is a runtime behaviour migration.

Jackson 3.x moved its root package from `com.fasterxml.jackson` to `tools.jackson`. This is a breaking namespace change across every import and every dependency in the POM. The Revenue platform ships a wrapper library (common-rest) that abstracts mapper construction, migrating it enables all downstream projects to follow the same pattern.

## Changes

### 1. Imports moved

Imports moved from `com.fasterxml.jackson.*` to `tools.jackson.*` in multiple modules.

| Action | GroupId | ArtifactId | Notes |
| :--- | :--- | :--- | :--- |
| Replace | `com.fasterxml.jackson.core` to `tools.jackson.core` | `jackson-core` | Managed by BOM |
| Replace | `com.fasterxml.jackson.core` to `tools.jackson.core` | `jackson-databind` | Managed by BOM |
| Keep | `com.fasterxml.jackson.core` | `jackson-annotations` | Annotations jar still uses the old groupId in Jackson 3 |
| Replace | `com.fasterxml.jackson.dataformat` to `tools.jackson.dataformat` | `jackson-dataformat-smile` | Managed by BOM |
| Replace | `com.fasterxml.jackson.module` to `tools.jackson.module` | `jackson-module-jsonschema` | Managed by BOM |

> **Note:** `jackson-annotations` intentionally stays under `com.fasterxml.jackson.core`. Jackson 3 deliberately retained the old groupId there for backward compatibility.

### 2. High level Java Import changes

| Old Import | New Import |
| :--- | :--- |
| `com.fasterxml.jackson.core.JsonProcessingException` | `tools.jackson.core.JacksonException` |
| `com.fasterxml.jackson.core.type.TypeReference` | `tools.jackson.core.type.TypeReference` |
| `com.fasterxml.jackson.databind.*` | `tools.jackson.databind.*` |
| `com.fasterxml.jackson.databind.json.JsonMapper` | `tools.jackson.databind.json.JsonMapper` |
| `com.fasterxml.jackson.databind.ObjectMapper` | `tools.jackson.databind.ObjectMapper` |
| `com.fasterxml.jackson.databind.SerializationFeature` | `tools.jackson.databind.SerializationFeature` |
| `com.fasterxml.jackson.databind.module.SimpleModule` | `tools.jackson.databind.module.SimpleModule` |
| `com.fasterxml.jackson.databind.SerializerProvider` | `tools.jackson.databind.SerializationContext` |
| `com.fasterxml.jackson.databind.introspect.*` | `tools.jackson.databind.introspect.*` |
| `com.fasterxml.jackson.databind.jsonFormatVisitors.*` | `tools.jackson.databind.jsonFormatVisitors.*` |
| `com.fasterxml.jackson.module.jsonSchema.*` | `tools.jackson.module.jsonSchema.*` |
| `com.fasterxml.jackson.dataformat.smile.SmileFactory` | `tools.jackson.dataformat.smile.SmileMapper` |

### 3. Exception Handling Changes

`JsonProcessingException` no longer needs to be declared or caught separately in Jackson 3. It is now an unchecked `JacksonException`.

```java
// Before
} catch (final JsonProcessingException e) { ... }
} catch (final IOException e) { ... }

// After
} catch (final JacksonException e) { ... }
```

### 4. FactoryBean Pattern for Custom Mappers

If a class previously extended `CustomJacksonObjectMapper`, it must be refactored to implement `FactoryBean<JsonMapper>` (Jackson 3 mappers are built immutably via builders. For example -

```java
// Before
public class MBeanObjectMapper extends CustomJacksonObjectMapper {
    public MBeanObjectMapper() {
        super();
        configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        this.registerModule(module);
    }
}

// After
public class MBeanObjectMapper implements FactoryBean<JsonMapper> {
    @Override
    public JsonMapper getObject() {
        JsonMapper.Builder builder = JsonMapper.builder()
            .disable(SerializationFeature.FAIL_ON_EMPTY_BEANS)
            .addModule(jmxModule);
        RevenueDefaultsJsonMapper.applyRevenueDefaults(builder);
        return builder.build();
    }
    @Override public Class<?> getObjectType() { return JsonMapper.class; }
    @Override public boolean isSingleton() { return true; }
}
```

Likewise, where code previously created a `CustomJacksonMapper`, it can now can get a similarly configured Jackson 3 `JsonMapper` by calling `RevenueDefaultsJsonMapper.create()`.

### 5. Smile Format

```java
// Before
objectMapper = new CustomJacksonObjectMapper(new SmileFactory()).newDateFormat();

// After
SmileMapper.Builder smileMapperBuilder = SmileMapper.builder();
RevenueDefaultsJsonMapper.applyRevenueDefaults(smileMapperBuilder);
objectMapper = smileMapperBuilder.build();
```

### 6. Spring Integration Changes

Spring 7 replaced the Jackson 2 HTTP message converter with a Jackson 3 native equivalent.

| Layer | Before | After |
| :--- | :--- | :--- |
| HTTP converter bean class | `MappingJackson2HttpMessageConverter` | `JacksonJsonHttpMessageConverter` |
| Mapper injection | `<property name="objectMapper" ref="..."/>` | `<constructor-arg ref="..."/>` |
| Removed property | `<property name="useSuffixPatternMatch" value="false"/>` | **Remove entirely** — property removed in Spring 6+ |

## Summary

This migration eliminates the project's dependency on the legacy `com.fasterxml.jackson` namespace and the Revenue-internal `CustomJacksonObjectMapper` wrapper, aligning the codebase with Jackson 3's immutable builder model and the updated RevenueDefaultsJsonMapper API in common-rest.
