Resources
---------
* [Resource Query Language: A Query Language for the Web, NoSQL](http://www.sitepen.com/blog/2010/11/02/resource-query-language-a-query-language-for-the-web-nosql/)
* [RSQL by kriszyp](https://github.com/kriszyp/rql)
* [RSQL jirutka](https://github.com/jirutka/rsql-parser)
* [OData Version 4.0](http://www.odata.org/documentation/odata-v4/)

Query Grammar
-------------
    Operators
        eq          equal
        ne          not equal
        gt          greater than
        ge          greater than or equal
        lt          less than
        le          less than or equal
        in          in condition
    Logical Operators
        and         logical and
        or          logical or
    Grouping Operators
        ()          precedence grouping
    Data Types
        string
        integer
        float
        boolean
        null        literal
    Matching string
        * or %      beginning/end of a string value

Order Grammar
-------------
    Operators
        sort

Range Grammar
-------------
    Operators
        limit
        page
