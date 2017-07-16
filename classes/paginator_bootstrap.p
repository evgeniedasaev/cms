##############################################################################
#
##############################################################################

@CLASS
PaginatorBootstrap

@USE
scroller.p

@BASE
scroller



##############################################################################
@create[items_count;items_per_page;form_name;direction;page]
	^BASE:init[$items_count;$items_per_page;$form_name;$direction;$page]
#end @create[]



###########################################################################
# выводит html постраничной навигации
# принимает параметры (хеш)
# $mode				- тип вывода html
# $nav_count		- количество отображаемых ссылок на страницы (по умолчанию 5)
# $separator		- разделитель пропусков в страницах (по умолчанию "…")
# $tag_name			- тег в котором все выводим
# $tag_attr			- аттрибуты тега
# $title			- заголовок постраничной навигации (по умолчанию "Страницы: ")
# $left_divider		- разделитель между "Назад" и первой страницей (по умолчанию "")
# $right_divider	- разделитель между последней страницей и "Дальше" (по умолчанию: "|")
# $back_name		- "< Назад"
# $forward_name		- "Дальше >"
# $target_url		- URL куда мы будем переходить (по умолчанию "./")

# пример вызова (после создания объекта $scroller):
# ^my_scroller.print[
#		$.mode[html]
#		$.target_url[./]
#		$.nav_count(9)
#		$.left_divider[|]
# ]

###########################################################################
# выводит постраничную навигацию
@print[in_params][lparams;nav_count;page_number;first_nav;last_nav;separator;url_separator;ipage;i;title]
	^if($page_count > 1){
		$lparams[^hash::create[$in_params]]

		$mode[html]

		$lparams.left_divider[$NULL]
		$lparams.right_divider[$NULL]

		$nav_count(^lparams.nav_count.int(5))
		$first_nav($current_page_number - $nav_count \ 2)

		^if($first_nav < 1){
			$first_nav(1)
		}

		$last_nav($first_nav + $nav_count - 1)

		^if($last_nav > $page_count){
			$last_nav($page_count)
			$first_nav($last_nav - $nav_count)
			^if($first_nav < 1){$first_nav(1)}
		}

		$separator[^if(def $lparams.separator){$lparams.separator}{&hellip^;}]
		$url_separator[^if(^lparams.target_url.pos[?]>=0){^taint[&]}{?}]

		^if(def $lparams.tag_name){
			$result[<$lparams.tag_name $lparams.tag_attr>]
		}

		$result[$result<nav class="pagination"><ul>]

		$title[^if(def $lparams.title){$lparams.title}]

		$result[$result$title]

		$result[$result^print_nav_item[^if($current_page == $first_page){back_disabled}{back};^if(def $lparams.back_name){$lparams.back_name}{&laquo^;};$lparams.target_url;$url_separator;^eval($current_page - $direction);^if($current_page == $first_page){disabled}]]

		^if($first_nav > 1){
			$result[$result^print_nav_item[first;1;$lparams.target_url;$url_separator;$first_page]]
			^if($first_nav > 2){
				$result[$result^print_nav_item[separator;$separator;class="more"]]
			}
		}

		^for[i]($first_nav;$last_nav){
			^if($direction < 0){
				$ipage($page_count - $i + 1)
			}{
				$ipage($i)
			}
			$result[$result^print_nav_item[^if($ipage == $current_page){current};$i;$lparams.target_url;$url_separator;$ipage;^if($ipage == $current_page){active}]]
		}

		^if($last_nav < $page_count){
			^if($last_nav < $page_count - 1){
				$result[$result^print_nav_item[separator;$separator;class="more"]]
			}
			^if(^lparams.show_last_page.bool(true)){
				$result[$result^print_nav_item[last;$page_count;$lparams.target_url;$url_separator;$last_page]]
			}
		}

		$result[$result^print_nav_item[^if($current_page == $last_page){forward_disabled}{forward};^if(def $lparams.forward_name){$lparams.forward_name}{&raquo^;};$lparams.target_url;$url_separator;^eval($current_page + $direction);^if($current_page == $last_page){disabled}]]

		$result[$result</ul></nav>]
		^if(def $lparams.tag_name){$result[$result</$lparams.tag_name>]}
	}
#end @print[]



###########################################################################
# выводит элемент постраничной навигации
@print_nav_item[type;name;url;url_separator;page_num;class]
	^if($mode eq "html"){
		^if($type eq "separator"){
			$result[<li class="separator">$name</li>]
		}{
			^if($type ne "current" && $type ne "back_disabled" && $type ne "forward_disabled" && def $page_num){
				$href[^untaint[html]{^if(def $url){$url}{./}^if($page_num != $first_page){${url_separator}$form_name=$page_num}}]

				$result[<li><a href="$href">$name</a></li>]
			}{
				$result[<li class="$class"><a href="#">$name</a></li>]
			}
		}
	}
#end @print_nav_item[]
