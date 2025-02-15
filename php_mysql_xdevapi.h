/*
  +----------------------------------------------------------------------+
  | PHP Version 7                                                        |
  +----------------------------------------------------------------------+
  | Copyright (c) The PHP Group                                          |
  +----------------------------------------------------------------------+
  | This source file is subject to version 3.01 of the PHP license,      |
  | that is bundled with this package in the file LICENSE, and is        |
  | available through the world-wide-web at the following url:           |
  | http://www.php.net/license/3_01.txt                                  |
  | If you did not receive a copy of the PHP license and are unable to   |
  | obtain it through the world-wide-web, please send a note to          |
  | license@php.net so we can mail you a copy immediately.               |
  +----------------------------------------------------------------------+
  | Authors: Andrey Hristov <andrey@php.net>                             |
  +----------------------------------------------------------------------+
*/
#ifndef PHP_MYSQL_XDEVAPI_H
#define PHP_MYSQL_XDEVAPI_H

#define PHP_MYSQL_XDEVAPI_VERSION "8.0.27"
#define MYSQL_XDEVAPI_VERSION_ID 80027
#define PHP_MYSQL_XDEVAPI_LICENSE "PHP License, version 3.01"
#define PHP_MYSQL_XDEVAPI_NAME   "mysql-connector-php"

#ifdef PHP_WIN32
#	ifdef PHP_MYSQL_XDEVAPI_EXPORTS
#		define PHP_MYSQL_XDEVAPI_API __declspec(dllexport)
#	elif defined(COMPILE_DL_MYSQL_XDEVAPI)
#		define PHP_MYSQL_XDEVAPI_API __declspec(dllimport)
#	else
#		define PHP_MYSQL_XDEVAPI_API PHPAPI
#	endif
#elif defined(__GNUC__) && __GNUC__ >= 4
#	define PHP_MYSQL_XDEVAPI_API __attribute__ ((visibility("default")))
#else
#	define PHP_MYSQL_XDEVAPI_API PHPAPI
#endif

#endif /*PHP_MYSQL_XDEVAPI_H*/
