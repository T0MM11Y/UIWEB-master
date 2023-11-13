/**
 * consumer
 */
var Consumer = {

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
    }
};
