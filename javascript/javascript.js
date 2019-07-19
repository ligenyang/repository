// 监听器 对象属性值的变化, 触发 set 方法
//var data = {name: 'kindeng'};
//observe(data);
//data.name = 'dmq'; // 哈哈哈，监听到值变化了 kindeng --> dmq

function observe(data) {
    debugger;
    if (!data || typeof data !== 'object') {
        return;
    }
    // 取出所有属性遍历
    Object.keys(data).forEach(function(key) {
        Object.keys(data[key]).forEach(function(k) {
            defineReactive(data, k, data[key]);
        });
    });
};

function defineReactive(data, key, val) {
    debugger;
    //observe(val); // 监听子属性
    Object.defineProperty(data, key, {
        enumerable: true, // 可枚举
        configurable: false, // 不能再define
        get: function() {
            debugger;
            return val;
        },
        set: function(newVal) {

            debugger;
            console.log('哈哈哈，监听到值变化了 ', val, ' --> ', newVal);
            val = newVal;
        }
    });
}


$('form').on('DOMNodeInserted', function() {
    _n('[name^="entity.chronicCode"]').attr('onchange', 'config_chronic_change(this)');
});