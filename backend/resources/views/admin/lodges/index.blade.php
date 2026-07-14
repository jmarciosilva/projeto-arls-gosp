@component('admin.layouts.app', ['title' => 'Lojas'])
    <div class="mb-6 flex items-center justify-between">
        <h1 class="text-xl font-semibold">Lojas GOSP</h1>
        <a href="{{ route('admin.lodges.create') }}"
            class="rounded-md bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700">
            + Cadastrar Loja
        </a>
    </div>

    @if (session('success'))
        <div class="mb-4 rounded-md bg-emerald-50 px-3 py-2 text-sm text-emerald-700">
            {{ session('success') }}
        </div>
    @endif

    <div class="overflow-hidden rounded-lg border border-slate-200 bg-white">
        <table class="w-full text-left text-sm">
            <thead class="bg-slate-50 text-slate-500">
                <tr>
                    <th class="px-4 py-3 font-medium">Nome</th>
                    <th class="px-4 py-3 font-medium">Número</th>
                    <th class="px-4 py-3 font-medium">Rito</th>
                    <th class="px-4 py-3 font-medium">Cidade/UF</th>
                    <th class="px-4 py-3 font-medium">E-mail</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @forelse ($lodges as $lodge)
                    <tr>
                        <td class="px-4 py-3">{{ $lodge->name }}</td>
                        <td class="px-4 py-3">{{ $lodge->number }}</td>
                        <td class="px-4 py-3">{{ $lodge->rite }}</td>
                        <td class="px-4 py-3">{{ $lodge->city }}/{{ $lodge->state }}</td>
                        <td class="px-4 py-3">{{ $lodge->email }}</td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-4 py-8 text-center text-slate-400">
                            Nenhuma Loja cadastrada ainda.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="mt-4">
        {{ $lodges->links() }}
    </div>
@endcomponent
