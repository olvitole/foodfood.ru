<?xml version="1.0" encoding="UTF-8"?>
<!-- Страница лица фуд фуд -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="xml" indent="yes" encoding="utf-8"
                doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

    <!-- Импорт макета -->
    <xsl:include href="../../layouts/pages.xsl" />
    <xsl:template match="/">
        <xsl:apply-templates select="root" />
    </xsl:template >

    <!-- Скидки -->
    <xsl:template match="content">
        <div id="additional">
            <div class="restaurant_header rounded">
                <div class="caption">
                    <div class="title">Cкидки</div>
                </div>
            </div>
            <div class="iphone"></div>
            <div class="discount_list">
                <xsl:apply-templates select="discounts/item" />
            </div>
            <div class="clear"></div>
        </div>
    </xsl:template>
    
    <xsl:template match="discounts/item">
        <div class="item" rel="{discount_percent}" partner="{rest_id}" percent="{discount_percent}">
            <div>
                <xsl:attribute name="class">
                    <xsl:choose>
                        <xsl:when test="discount_percent>15">percent sale20 rounded shadow_box</xsl:when>
                        <xsl:when test="discount_percent>5">percent sale15 rounded shadow_box</xsl:when>
                        <xsl:when test="discount_percent>0">percent sale5 rounded shadow_box</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:value-of select="discount_percent" /><span>%</span>
            </div>
            <div class="name">
                <xsl:call-template name="rest_link">
                    <xsl:with-param name="id" select="rest_id" />
                    <xsl:with-param name="uri" select="rest_uri" />
                    <xsl:with-param name="title" select="rest_title" />
                </xsl:call-template>
                <div class="count">осталось: <xsl:value-of select="discount_count" /></div>
            </div>
            <div class="discount_description" style="display:none;">
                <xsl:value-of select="discount_description" disable-output-escaping="yes" />
            </div>
            <div class="clear"></div>
        </div>
    </xsl:template>

</xsl:stylesheet>