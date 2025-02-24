let selectedBottle = null;
let maxFillAmount = 0;

$(document).ready(function() {
    // Başlangıçta UI'ı gizle
    $('#water-container').hide();

    window.addEventListener('message', function(event) {
        if (event.data.action === "openWaterUI") {
            $('#water-container').show();
            if (event.data.bottles && event.data.bottles.length > 0) {
                setupBottles(event.data.bottles);
            }
        } else if (event.data.action === "closeWaterUI") {
            $('#water-container').hide();
        }
    });

    $('#amount-slider').on('input', function() {
        let value = $(this).val();
        $('#amount-display').text(value + '%');
        $('.water').css('height', value + '%');
    });

    $('#bottle-selector').on('change', function() {
        selectedBottle = $(this).val();
        if (selectedBottle) {
            let bottle = $(this).find(':selected').data('bottle');
            maxFillAmount = 100 - bottle.currentAmount;
            $('#amount-slider').attr('max', maxFillAmount);
            $('#amount-slider').val(0);
            $('#amount-display').text('0%');
        }
    });

    $('#fill-button').click(function() {
        if (selectedBottle && $('#amount-slider').val() > 0) {
            $.post(`https://${GetParentResourceName()}/fillBottle`, JSON.stringify({
                bottleType: selectedBottle,
                amount: parseInt($('#amount-slider').val())
            }));
            $('#water-container').hide();
        }
    });

    $('#cancel-button').click(function() {
        $.post(`https://${GetParentResourceName()}/closeUI`, JSON.stringify({}));
        $('#water-container').hide();
    });

    // ESC tuşu ile kapatma
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post(`https://${GetParentResourceName()}/closeUI`, JSON.stringify({}));
            $('#water-container').hide();
        }
    });
});

function setupBottles(bottles) {
    let selector = $('#bottle-selector');
    selector.empty();
    selector.append('<option value="">Select a Bottle</option>');
    
    bottles.forEach(bottle => {
        selector.append(`<option value="${bottle.type}" data-bottle='${JSON.stringify(bottle)}'>
            ${bottle.label} (${bottle.currentAmount}% Full)
        </option>`);
    });
} 