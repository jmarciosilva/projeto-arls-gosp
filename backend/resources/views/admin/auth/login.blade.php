<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Entrar — {{ config('app.name') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="flex min-h-screen items-center justify-center bg-slate-50 text-slate-900">
    <div class="w-full max-w-sm rounded-xl border border-slate-200 bg-white p-8 shadow-sm">
        <h1 class="mb-1 text-lg font-semibold">{{ config('app.name') }}</h1>
        <p class="mb-6 text-sm text-slate-500">Acesso do administrador da plataforma</p>

        @if ($errors->any())
            <div class="mb-4 rounded-md bg-red-50 px-3 py-2 text-sm text-red-700">
                {{ $errors->first() }}
            </div>
        @endif

        <form method="POST" action="{{ route('admin.login.store') }}" class="space-y-4">
            @csrf
            <div>
                <label for="email" class="mb-1 block text-sm font-medium text-slate-700">E-mail</label>
                <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus
                    class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
            </div>
            <div>
                <label for="password" class="mb-1 block text-sm font-medium text-slate-700">Senha</label>
                <input id="password" type="password" name="password" required
                    class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
            </div>
            <button type="submit"
                class="w-full rounded-md bg-slate-900 px-3 py-2 text-sm font-medium text-white hover:bg-slate-700">
                Entrar
            </button>
        </form>
    </div>
</body>
</html>
