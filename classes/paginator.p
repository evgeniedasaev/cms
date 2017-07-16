##############################################################################
#	
##############################################################################

@CLASS
Paginator

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
# $mode				- тип вывода. сейчас умеет: html|xml
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

@print[in_params][lparams;nav_count;page_number;first_nav;last_nav;separator;url_separator;ipage;i;title]
^if($page_count > 1){
	$lparams[^hash::create[$in_params]]
	^if(def $lparams.mode){
		$mode[$lparams.mode]
	}
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
	$separator[^if(def $lparams.separator){$lparams.separator}{…}]
	$url_separator[^if(^lparams.target_url.pos[?]>=0){^taint[&]}{?}]
	^if(def $lparams.tag_name){
		$result[<$lparams.tag_name $lparams.tag_attr>]
	}
	$title[^if(def $lparams.title){$lparams.title}{Страницы: }]
	^if($mode eq "html"){
		$result[$result$title]
	}{
		<title>$title</title>
		^if(def $lparams.left_divider){<left-divider>$lparams.left_divider</left-divider>}
		^if(def $lparams.right_divider){<right-divider>$lparams.right_divider</right-divider>}
	}
	^if($current_page != $first_page && def $lparams.back_name){
		$result[$result^print_nav_item[back;^if(def $lparams.back_name){$lparams.back_name}{&larr^; Назад};$lparams.target_url;$url_separator;^eval($current_page - $direction)]]
		^if($mode eq "html"){
			$result[$result^if(def $lparams.left_divider){$lparams.left_divider}]
		}
	}
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
		$result[$result^print_nav_item[^if($ipage == $current_page){current};$i;$lparams.target_url;$url_separator;$ipage]]
	}
	^if($last_nav < $page_count){
		^if($last_nav < $page_count - 1){
			$result[$result^print_nav_item[separator;$separator;class="more"]]
		}
		^if(^lparams.show_last_page.bool(true)){
			$result[$result^print_nav_item[last;$page_count;$lparams.target_url;$url_separator;$last_page]]
		}
	}
	^if($current_page != $last_page && def $lparams.forward_name){
		^if($mode eq "html"){
			^if($lparams.right_divider is void){|}{$lparams.right_divider}
		}
		$result[$result^print_nav_item[forward;^if(def $lparams.forward_name){$lparams.forward_name}{Дальше&nbsp^;&rarr^;};$lparams.target_url;$url_separator;^eval($current_page + $direction);class="forward"]]
	}
	^if(def $lparams.tag_name){$result[$result</$lparams.tag_name>]}
}
#end @print[]



###########################################################################
# выводит элемент постраничной навигации
@print_nav_item[type;name;url;url_separator;page_num;attr]
^if($mode eq "html"){
	^if($type eq "separator"){
		$result[<span^if(def $url){ $url}>$name</span>]
	}{
		^if($type ne "current" && def $page_num){
			$result[<a href="^untaint[html]{^if(def $url){$url}{./}^if($page_num != $first_page){${url_separator}$form_name=$page_num}}"^if(def $attr){ $attr}>$name</a>]]
		}{
			$result[<span^if(def $attr){ $attr}>$name</span>]
		}
	}
}{
	$result[<page
		^if(def $type){ type="$type"}
		^if($type ne "current" && def $page_num){
			href="^untaint[xml]{^if(def $url){$url}{./}^if($page_num != $first_page){${url_separator}$form_name=$page_num}}"
		}
		num="$name"
	/>]
}
#end @print_nav_item[]
