/**
 * Message
 */
var Messsage = {
    
    bindFancyBox: function () {

        $('[name="edit"]').click(function() {
            $.fancybox({
                'minWidth': 500,
                'minHeight': 200,
                'width': '60%',
                'height': '60%',
                'autoSize': false,
                'type': 'iframe',
                'href': $(this).attr('data-link')
            });
        });

        $('[name="consumer_list"]').click(function() {
            $.fancybox({
                'minWidth': 800,
                'minHeight': 600,
                'width': '79%',
                'height': '60%',
                'autoSize': false,
                'type': 'iframe',
                'href': $(this).attr('data-link')
            });
        });

        $('[name="source_info"]').click(function() {
            $.fancybox({
                'minWidth': 800,
                'minHeight': 600,
                'width': '79%',
                'height': '60%',
                'autoSize': false,
                'type': 'iframe',
                'href': $(this).attr('data-link')
            });
        })
    }
};
