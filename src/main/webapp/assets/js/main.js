/**
 * ES TEH SOLO - Interactive Frontend Logic
 */

document.addEventListener('DOMContentLoaded', () => {
    initCartHandlers();
    initReviewModal();
    initLiveSearch();
    initAutoDismissAlerts();
});

// Toast notification helper
function showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.style.cssText = `
            position: fixed;
            bottom: 24px;
            right: 24px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        `;
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    const isSuccess = type === 'success';
    toast.style.cssText = `
        background: ${isSuccess ? '#245C38' : '#EF4444'};
        color: #FFFFFF;
        padding: 14px 22px;
        border-radius: 12px;
        font-weight: 600;
        font-size: 0.92rem;
        box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        display: flex;
        align-items: center;
        gap: 10px;
        opacity: 0;
        transform: translateY(20px);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    `;

    toast.innerHTML = `
        <span>${isSuccess ? '🍃' : '⚠️'}</span>
        <span>${message}</span>
    `;

    container.appendChild(toast);

    requestAnimationFrame(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateY(0)';
    });

    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateY(10px)';
        setTimeout(() => toast.remove(), 300);
    }, 3200);
}

// Cart AJAX handler
function initCartHandlers() {
    document.querySelectorAll('.btn-add-cart-ajax').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const productId = this.dataset.productId;
            const productName = this.dataset.productName || 'Minuman';

            const originalText = this.innerHTML;
            this.innerHTML = '<span>Menambahkan...</span>';
            this.disabled = true;

            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('productId', productId);
            formData.append('quantity', '1');
            formData.append('ajax', 'true');

            fetch(`${window.contextPath || ''}/cart`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData.toString()
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Update all badge counters
                    document.querySelectorAll('.cart-count').forEach(badge => {
                        badge.textContent = data.totalCount;
                        badge.style.display = data.totalCount > 0 ? 'flex' : 'none';
                        badge.classList.add('bounce');
                        setTimeout(() => badge.classList.remove('bounce'), 400);
                    });
                    showToast(data.message || `${productName} berhasil ditambahkan ke keranjang!`);
                } else {
                    showToast(data.message || 'Gagal menambahkan ke keranjang.', 'danger');
                }
            })
            .catch(err => {
                console.error(err);
                showToast('Gagal menambahkan ke keranjang.', 'danger');
            })
            .finally(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            });
        });
    });
}

// Review & Rating Modal Handler
function initReviewModal() {
    const modal = document.getElementById('reviewModal');
    if (!modal) return;

    window.openReviewModal = function(productId, productName) {
        document.getElementById('modalProductId').value = productId;
        document.getElementById('modalProductName').textContent = productName;
        modal.classList.add('active');
    };

    window.closeReviewModal = function() {
        modal.classList.remove('active');
    };

    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            closeReviewModal();
        }
    });

    // Star rating picker
    const stars = modal.querySelectorAll('.star-btn');
    const ratingInput = document.getElementById('modalRatingInput');

    stars.forEach(star => {
        star.addEventListener('click', function() {
            const val = parseInt(this.dataset.value);
            ratingInput.value = val;
            stars.forEach(s => {
                const sVal = parseInt(s.dataset.value);
                s.style.color = sVal <= val ? '#F59E0B' : '#CBD5E1';
            });
        });
    });
}

// Live search in menu
function initLiveSearch() {
    const searchInput = document.getElementById('menuSearchInput');
    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
        const query = this.value.toLowerCase().trim();
        const cards = document.querySelectorAll('.product-card');

        cards.forEach(card => {
            const title = (card.dataset.name || '').toLowerCase();
            const desc = (card.dataset.desc || '').toLowerCase();
            if (title.includes(query) || desc.includes(query)) {
                card.style.display = 'flex';
            } else {
                card.style.display = 'none';
            }
        });
    });
}

// Auto dismiss alerts
function initAutoDismissAlerts() {
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });
}
