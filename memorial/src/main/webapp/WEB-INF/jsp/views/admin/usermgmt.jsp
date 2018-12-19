<link rel="stylesheet" href="${contextPath}/resources/css/daterangepicker.css">
<div>UserMgmt Body</div>
<input type="text" id="dp">
<script type="text/javascript" src="${contextPath}/resources/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/daterangepicker.js"></script>
<script type="text/javascript">
$('#dp').daterangepicker({
    autoUpdateInput: false,
    locale: {
        cancelLabel: 'Clear'
    },
    ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
     }
});
</script>
