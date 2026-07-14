<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ $title ?? 'Painel' }} — {{ config('app.name') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    @livewireStyles
</head>
<body class="min-h-screen bg-slate-50 text-slate-900">
    <nav class="border-b border-slate-200 bg-white">
        <div class="mx-auto flex max-w-5xl items-center justify-between px-6 py-4">
            <a href="{{ route('admin.lodges.index') }}" class="font-semibold tracking-tight">
                {{ config('app.name') }} <span class="text-slate-400 font-normal">· Admin</span>
            </a>
            @auth
                <form method="POST" action="{{ route('admin.logout') }}">
                    @csrf
                    <button type="submit" class="text-sm text-slate-500 hover:text-slate-900">
                        Sair ({{ auth()->user()->name }})
                    </button>
                </form>
            @endauth
        </div>
    </nav>

    <main class="mx-auto max-w-5xl px-6 py-10">
        {{ $slot }}
    </main>

    @livewireScripts
</body>
</html>
