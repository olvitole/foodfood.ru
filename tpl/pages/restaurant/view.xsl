<?xml version="1.0" encoding="UTF-8"?>
<!-- Страница информации о ресторане -->
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

    <!-- Код страницы -->
    <xsl:template match="content">
        <!-- Информация о ресторане -->
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript">
            rest_page_activate = true;
            current_rest_id = <xsl:value-of select="restaurant/id" />;
            function map_init() {
            x_coord = '<xsl:value-of select="restaurant/rest_google_x" />';
            y_coord = '<xsl:value-of select="restaurant/rest_google_y" />';
            if (x_coord.replace(/(^\s+)|(\s+$)/g, "")!='') {x_coord = parseInt(x_coord);} else {x_coord = 0;}
            if (y_coord.replace(/(^\s+)|(\s+$)/g, "")!='') {y_coord = parseInt(y_coord);} else {y_coord = 0;}
            var latlng = new google.maps.LatLng(x_coord+0.002000,y_coord);
            var latlng_marker = new google.maps.LatLng(x_coord,y_coord);
            var myOptions = {
            zoom: 16,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
            var infowindow = new google.maps.InfoWindow({
            content: $($('#map_text').html()).get(0)
            });
            var marker_image = $('#map_marker img').attr('src');
            var marker = new google.maps.Marker({
            position: latlng_marker,
            map: map,
            icon: marker_image,
            title: 'Шоколадница'
            });
            infowindow.open(map,marker);
            google.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map,marker);
            });
            }
        </script>
        <xsl:apply-templates select="restaurant" />
    </xsl:template >

    <!-- Информация о ресторане -->
    <xsl:template match="restaurant">
        <div id="restaurant">
            <div class="restaurant_header rounded">
                <!-- Ссылка на предыдущий ресторан -->
                <div style="margin:0 auto; max-width:1600px;">
                    <a>
                        <xsl:choose>
                            <xsl:when test="//content/navigate/prev/id!=''">
                                <xsl:attribute name="href">
                                    <xsl:text>/</xsl:text>
                                    <xsl:value-of select="//site/city" />
                                    <xsl:text>/restaurant/</xsl:text>
                                    <xsl:choose>
                                        <xsl:when test="//content/navigate/prev/rest_uri!=''">
                                            <xsl:value-of select="//content/navigate/prev/rest_uri" />
                                        </xsl:when>
                                        <xsl:when test="//content/navigate/prev/rest_uri=''">
                                            <xsl:value-of select="//content/navigate/prev/rest_id" />
                                        </xsl:when>
                                    </xsl:choose>
                                    <xsl:text>-</xsl:text>
                                    <xsl:value-of select="//content/navigate/mood" />
                                    <xsl:text>-</xsl:text>
                                    <xsl:value-of select="//content/navigate/offset+1-2" />
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                        <div class="back"></div>
                    </a>

                    <div>
                        <div class="caption">
                            <div class="title"><xsl:value-of select="mood_title" /> <xsl:if test="mood_title != ''">: </xsl:if>  <xsl:value-of select="rest_title" /></div>
                        </div>
                        <!-- Ссылка на следующий ресторан -->
                        <a>
                            <xsl:choose>
                                <xsl:when test="//content/navigate/next/id!=''">
                                    <xsl:attribute name="href">
                                        <xsl:text>/</xsl:text>
                                        <xsl:value-of select="//site/city" />
                                        <xsl:text>/restaurant/</xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="//content/navigate/next/rest_uri!=''">
                                                <xsl:value-of select="//content/navigate/next/rest_uri" />
                                            </xsl:when>
                                            <xsl:when test="//content/navigate/next/rest_uri=''">
                                                <xsl:value-of select="//content/navigate/next/rest_id" />
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="//content/navigate/mood" />
                                        <xsl:text>-</xsl:text>
                                        <xsl:value-of select="//content/navigate/offset+1" />
                                    </xsl:attribute>
                                </xsl:when>
                            </xsl:choose>
                            <div class="next"></div>
                        </a>
                        <div class="rest_rating">
                            <div class="minus"></div>
                            <div class="rating_line"><xsl:value-of select="rest_rating" /></div>
                            <div class="plus"></div>
                    </div></div>
                </div>
            </div>
            <div class="restaurant_tags">
                <xsl:apply-templates select="tags/item" />
                <xsl:if test="worktime!=''">
                    <div>
                        <xsl:choose>
                            <xsl:when test="worktime/opened=1">
                                <xsl:attribute name="class">work_time opened</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="class">work_time closed</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="worktime/time_start"/> до
                        <xsl:value-of select="worktime/time_end"/> <br />
                        <xsl:choose>
                            <xsl:when test="worktime/opened=1">
                                <span>Открыто</span>
                            </xsl:when>
                            <xsl:otherwise>
                                <span style="color:#FF6600">Закрыто</span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </xsl:if>
            </div>
            <div class="clear"></div>
            <div class="clear marginTop20px"></div>
            <!-- Вывод  информации по ресторану -->

            <div id="restaurant_info">
                <!-- Левая колонка -->
                <div class="left_col">
                    <div class="photos">
                        <div class="main_container">
                            <xsl:choose>
                                <xsl:when test="photos=''">
                                    <a href="/public/images/rest_icon_big.jpg">
                                        <img src="/public/images/rest_icon_big.jpg" class="main" alt="{rest_title}" />
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="/upload/image/rest_photo/{id}/{photos/item/src}">
                                        <img src="/upload/image/rest_photo/{id}/{photos/item/src}" class="main" alt="{rest_title}" />
                                    </a>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <div>
                            <xsl:if test="photos=''">
                                <img src="/public/images/rest_icon_big.jpg" class="mini" alt="{rest_title}" />
                            </xsl:if>
                            <xsl:apply-templates select="photos/item" />
                        </div>
                        <div class="clear"></div>
                    </div>

                    <div class="rest_params">
                        <xsl:if test="categories != ''"><span class="param_type">Тип: </span> <xsl:value-of select="categories" /><br /></xsl:if>
                        <xsl:if test="cooks != ''"><span class="param_type">Кухня: </span> <xsl:value-of select="cooks" /><br /></xsl:if>
                        <xsl:if test="diets != ''"><span class="param_type">Меню: </span> <xsl:value-of select="diets" /><br /></xsl:if>
                        <xsl:if test="musics != ''"><span class="param_type">Музыка: </span> <xsl:value-of select="musics" /><br /></xsl:if>
                        <xsl:if test="payments != ''"><span class="param_type">Способы оплаты: </span> <xsl:value-of select="payments" /><br /></xsl:if>
                    </div>
                    <div class="rest_description">
                        <xsl:value-of select="rest_description" disable-output-escaping="yes" />
                    </div>
                    <div class="rest_contacts">
                        <xsl:if test="rest_phone != ''">
                            <div class="phone"><xsl:value-of select="rest_phone" /></div>
                        </xsl:if>
                        <xsl:if test="rest_address != ''">
                            <div class="address">
                                <xsl:value-of select="rest_address" />  <span class="map_link"><a href="#">Карта проезда</a></span>
                            </div>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="rest_metro!=''">
                                <div class="metro"><xsl:value-of select="rest_metro" /></div>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="rest_ostanovka!=''">
                                <div class="ostanovka"><xsl:value-of select="rest_ostanovka" /></div>
                            </xsl:when>
                        </xsl:choose>
                    </div>

                    <div class="person_block">
                        <div class="caption">Приятного аппетита желает:</div>
                        <div class="photo">
                            <a href="/{//site/city}/persons/view/{//person/id}">
                                <img src="/upload/image/persons/medium-{//person/uri}.jpg" alt="{//person/person_name}" />
                            </a>
                        </div>
                        <div class="text">
                            <div class="fio">
                                <a href="/{//site/city}/persons/view/{//person/id}">
                                    <xsl:value-of select="//person/person_name" />
                                </a>
                            </div>
                            <xsl:value-of select="//person/person_post" /><br />
                            <br />
                            <xsl:value-of select="//person/person_text" />
                        </div>
                        <div class="clear"></div>

                    </div>
                </div>
                <!-- Средняя колонка -->
                <div class="center_col">
                    <div class="news">
                        <xsl:if test="posters!=''">
                            <div class="caption orange">Не пропустите: </div>
                            <xsl:apply-templates select="posters/item" />
                        </xsl:if>
                    </div>
                    <div class="rest_reviews">
                        <div class="caption">Отзывы</div>
                        <div class="reviews">
                            <xsl:if test="count(reviews/item)=0">
                                <div style="padding:10px 0;">Ты можешь оставить отзыв первым!</div>
                            </xsl:if>
                            <xsl:apply-templates select="reviews/item" />
                            <div class="form">
                                <form action="" method="post">
                                    <textarea name="text" class="rounded"></textarea>
                                    <input type="submit" value="Отправить" />
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Правая колонка -->
                <div class="right_col">
                    <div class="links">
                        <div class="rounded border_1px_6e6e6e padding10">
                            <ul>
                                <xsl:choose>
                                    <xsl:when test="partner!=''">
                                        <li class="link discount_icon">
                                            <a href="#" partner="{id}" percent="{partner/discount_percent}">Получить скидку</a>
                                            <div class="discount_description">
                                                <xsl:value-of select="partner/discount_description" disable-output-escaping="yes" />
                                            </div>
                                        </li>
                                    </xsl:when>
                                </xsl:choose>
                                <li class="link dostavka_icon"><a href="#">Доставить еду</a></li>
                                <li class="link"><a href="#">Забронировать столик</a></li>
                                <li class="link"><a href="#">Заказать банкет</a></li>
                            </ul>
                            <xsl:if test="false">
                                <div class="menu_link menu_icon">
                                    <a href="#">
                                        <xsl:attribute name="href">
                                            <xsl:text>/</xsl:text>
                                            <xsl:value-of select="//site/city" />
                                            <xsl:text>/menu/</xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="rest_uri!=''">
                                                    <xsl:value-of select="rest_uri" />
                                                </xsl:when>
                                                <xsl:when test="rest_uri=''">
                                                    <xsl:value-of select="id" />
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:text>Меню пожалуйста!</xsl:text>
                                    </a>
                                    <ul class="sub_menu_link">
                                        <li class="bar_icon">
                                            <a href="#">
                                                <xsl:attribute name="href">
                                                    <xsl:text>/</xsl:text>
                                                    <xsl:value-of select="//site/city" />
                                                    <xsl:text>/menu/map/</xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when test="rest_uri!=''">
                                                            <xsl:value-of select="rest_uri" />
                                                        </xsl:when>
                                                        <xsl:when test="rest_uri=''">
                                                            <xsl:value-of select="id" />
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </xsl:attribute>
                                                <xsl:text>Карта бара</xsl:text>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                            </xsl:if>
                        </div>
                    </div>
                    <img src="/public/images/rest_banner.jpg" style="width:206px;margin-top:10px;" />
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div id="google_dialog" class="dialog_box dialog box_shadow">
            <div class="caption">
                <img class="close_button" src="/public/images/icons/close_icon.jpg" alt="закрыть" style="margin:0" />
                <div class="clear"></div>
                <div id="map_canvas" style="width:700px; height:500px"></div>
            </div>
        </div>
        <div id="map_text" style="display:none;">
            <div style="height:200px; width:500px;font-size:14px;">
                <img src="/public/images/logo.png" style="width:100px;height:80px;" />
                <div>
                    <div class="rest_contacts">
                        <xsl:if test="rest_phone != ''">
                            <div class="phone"><xsl:value-of select="rest_phone" /></div>
                        </xsl:if>
                        <xsl:if test="rest_address != ''">
                            <div class="address">
                                <xsl:value-of select="rest_address" />
                            </div>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="rest_metro!=''">
                                <div class="metro"><xsl:value-of select="rest_metro" /></div>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="rest_ostanovka!=''">
                                <div class="ostanovka"><xsl:value-of select="rest_ostanovka" /></div>
                            </xsl:when>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>
        <div id="map_marker" style="display:none;">
            <xsl:choose>
                <xsl:when test="rest_logo=''">
                    <img src="/public/images/icons/rest_logo_icon.gif" />
                </xsl:when>
                <xsl:otherwise>
                    <img src="/upload/image/rest_logo/{rest_uri}.jpg" />
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- Список новостей -->
    <xsl:template match="posters/item">
        <div class="news_item">
            <div class="photo box_shadow">
                <xsl:choose>
                    <xsl:when test="img=''">
                        <img src="/public/images/poster_icon.jpg" alt="{title}" />
                    </xsl:when>
                    <xsl:otherwise>
                        <img src="/upload/image/poster/{img}" alt="{title}" />
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div class="text_block"><div class="title"><a href="#"><xsl:value-of select="title" /></a></div>
            <div class="text"><xsl:value-of select="anounce" /></div></div>
        </div>
        <div class="clear"></div>
    </xsl:template>

    <!-- Список отзывов -->
    <xsl:template match="reviews/item">
        <div class="review">
            <div class="user"><xsl:value-of select="user_login" /> говорит:</div>
            <div class="text">« <xsl:value-of select="text" /> »</div>
        </div>
    </xsl:template>

    <!-- Список фотографий -->
    <xsl:template match="photos/item">
        <img src="/upload/image/rest_photo/{../../id}/mini-{src}" rel="/upload/image/rest_photo/{../../id}/{src}" class="mini" />
    </xsl:template>

    <!-- Список тэгов -->
    <xsl:template match="restaurant/tags/item">
        <div class="item rounded">
            <div class="img">
                <img src="/public/images/tags/{uri}.png" alt="{title}" />
            </div>
            <div class="text"><xsl:value-of select="title" /></div>
        </div>
    </xsl:template>

</xsl:stylesheet>