<?php
/**
 *  
 * @param array $arr  
 * @param boolean $fix 
 * @return string  
 * @author shenxin
 * @date 2012-5-4 09:30:13
 * @version V1R6B005
 */
//function array_to_json($arr, $fix = true)
function json_encode($arr, $fix = true)
{
    $parts      = array();
    $is_list    = false;
    /* Find out if the given array is a numerical array */
    $keys       = array_keys($arr);
    $max_length = count($arr) - 1;
    /* See if the first key is 0 and last key is length - 1 */
    if (($keys['0'] == '0') && ($keys[$max_length] == $max_length)) {
        $is_list = true;
        /* See if each key correspondes to its position */
        for ($i = 0; $i < count($keys); $i++) {
            /* A key fails at position check. */
            if ($i != $keys[$i]) {
                /* It is an associative array. */
                $is_list = false;
                break;
            }
        }
    }
    foreach ($arr as $key => $value) {
        /* Custom handling for arrays */
        if (is_array($value)) {
            if ($is_list) {
                /* :RECURSION: */
                $parts[] = array_to_json($value, $fix);
            } else {
                /* :RECURSION: */
                $parts[] = ($fix ? '"' : '') . $key . ($fix ? '":' : ':') . array_to_json($value, $fix);
            }
        } else {
            $str = '';
            if (!$is_list)
                $str = ($fix ? '"' : '') . $key . ($fix ? '":' : ':');
            /* Custom handling for multiple data types */
            if (is_numeric($value))
                $str .= $value;
            /* Numbers */
            elseif ($value === false)
                $str .= 'false'; /* The booleans */ 
            elseif ($value === true)
                $str .= 'true';
            else
                $str .= '"' . addslashes($value) . '"';
            /* All other things */
            /* Is there any more datatype we should be in the lookout for? (Object?) */
            $parts[] = $str;
        }
    }
    $json = implode(',', $parts);
    if ($is_list)
        return '[' . str_replace(array(
            "\r\n"
        ), '', $json) . ']';
    /* Return numerical JSON */
    return '{' . str_replace(array(
        "\r\n"
    ), '', $json) . '}';
    /* Return associative JSON */
}

/**
 * 
 *  
 * @param string $jsonStr  
 * @param boolean $obj  
 * @return return_type
 * @author shenxin
 * @date 2012-5-4ÉÏÎç09:31:37
 * @version V1R6B005
 */
//function json_to_array($jsonStr, $obj = false)
function json_decode($jsonStr, $obj = false)
{
    $str      = str_replace(array(
        ':',
        '{',
        '[',
        '}',
        ']'
    ), array(
        '=>',
        'array(',
        'array(',
        ')',
        ')'
    ), substr($jsonStr, 1, -1));
    $callback = @eval("return array({$str});");
    return $obj ? array_to_object($callback) : $callback;
}

/**
 * @param array $array
 * @param object $class
 * @author shenxin@adyimi.com
 * @date 2012-7-4
 */
function array_to_object($array, $class = 'stdClass')
{
    $array = !is_array($array) ? array(
        $array
    ) : $array;
    $obj   = new $class();
    foreach ($array as $k => $v) {
        $obj->$k = is_array($v) ? array_to_object($v, $class) : $v;
    }
    return $obj;
}

?>
