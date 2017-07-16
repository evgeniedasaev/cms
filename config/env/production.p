##############################################################################
#	
##############################################################################

#$CONFIG:debug_level(2)
#$CONFIG:logger_level[INFO]
#$CONFIG:logger_level[DEBUG]

$PARTIAL_CACHE_TIME(60 * 60)
$NAVIGATION_CACHE_TIME(60 * 60)
$GLOBAL_CACHE_TIME(60 * 60 * 24)

$HTTP_PROTOCOL[http://]
$HTTP_HOST[beta.dombutik.ru]

# $self.oMemcached[^memcached::open[
# 	$.server[127.0.0.1:11211]
# 	$.binary-protocol(true)
# 	$.connect-timeout(5)
# 	$.tcp-keepalive(true)
# ]($self.GLOBAL_CACHE_TIME)]

# ^use[/../framework/cache/memcache_store.p]
# ^use[/../classes/web_memcache_store.p]
# $self.oCacheStore[^WebMemcacheStore::create[$self.oMemcached]]