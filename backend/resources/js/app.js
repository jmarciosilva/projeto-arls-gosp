import './bootstrap';

window.maskCep = (value) => {
    return value
        .replace(/\D/g, '')
        .slice(0, 8)
        .replace(/^(\d{5})(\d)/, '$1-$2');
};

window.maskCpf = (value) => {
    const digits = value.replace(/\D/g, '').slice(0, 11);
    const parts = [digits.slice(0, 3), digits.slice(3, 6), digits.slice(6, 9)].filter(Boolean);
    const last = digits.slice(9, 11);

    let result = parts.join('.');
    if (last) result += `-${last}`;

    return result;
};

window.maskWhatsapp = (value) => {
    const digits = value.replace(/\D/g, '').slice(0, 11);

    if (digits.length <= 10) {
        return digits.replace(/^(\d{2})(\d{4})(\d{0,4})$/, (m, a, b, c) => c ? `(${a}) ${b}-${c}` : (b ? `(${a}) ${b}` : `(${a}`));
    }

    return digits.replace(/^(\d{2})(\d{5})(\d{0,4})$/, (m, a, b, c) => c ? `(${a}) ${b}-${c}` : (b ? `(${a}) ${b}` : `(${a}`));
};
