<?php
/**
 * @package PapipuEngine
 * @author valmon, z-mode
 * @version 0.2
 * Страница получения скидок
 */
class discount_Page extends View {

    /*
     * Инициализация страницы
    */
    public static function initController ($action) {
        // Получаем список настроений
        $moods=MD_Mood::getMoods();
        // Получаем список тэгов
        $tags=MD_Mood::getTags();

        self::$page['site']['city'] = CityPlugin::getCity();
        self::$page['site']['title'] = "Скидки Казань";
        self::$page['site']['keywords'] = "скидки казань, акции Казань, распродажи Казань";
        self::$page['site']['description'] = '';
        self::$page['content']['moods']=$moods;
        self::$page['content']['tags']=$tags;
        self::$page['header']['banner']['type'] = 'horizontal';
        self::$page['header']['banner']['class'] = 'banner770';
    }

    /*
     * Показ страницы скидок
    */
    public static function indexAction ($uri) {

        self::$page['site']['page'] = 'Скидки';
        self::$page['content']['discounts'] = MD_Discount::getDiscounts();

        self::showXSLT('pages/discount/index');
    }

    /*
     * Ajax действие получения скидки
    */
    public static function getAjaxAction ($id) {
        // Получаем данные из POST
        echo MD_Discount::getDiscount($_POST['phone'],$_POST['email'],$_POST['name'],$id);
        if (!empty($_POST['registration'])) {
            MD_Auth::registration($_POST['name'],$_POST['mail'],$_POST['phone']);
        }
    }
}