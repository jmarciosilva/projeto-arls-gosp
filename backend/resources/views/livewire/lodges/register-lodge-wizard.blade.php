<div>
    <div class="mb-6">
        <h1 class="text-xl font-semibold">Cadastrar Loja</h1>
        <p class="text-sm text-slate-500">Potência: <strong>{{ config('lodge.power') }}</strong> (fixa)</p>
    </div>

    <div class="mb-8 flex items-center gap-3 text-sm">
        <div class="flex items-center gap-2 {{ $step === 1 ? 'font-semibold text-slate-900' : 'text-slate-400' }}">
            <span class="flex h-6 w-6 items-center justify-center rounded-full {{ $step === 1 ? 'bg-slate-900 text-white' : 'bg-slate-200' }}">1</span>
            Dados da Loja
        </div>
        <div class="h-px w-8 bg-slate-300"></div>
        <div class="flex items-center gap-2 {{ $step === 2 ? 'font-semibold text-slate-900' : 'text-slate-400' }}">
            <span class="flex h-6 w-6 items-center justify-center rounded-full {{ $step === 2 ? 'bg-slate-900 text-white' : 'bg-slate-200' }}">2</span>
            Endereço e Administrador
        </div>
    </div>

    <div class="rounded-lg border border-slate-200 bg-white p-6">
        @if ($step === 1)
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div class="sm:col-span-2">
                    <label class="mb-1 block text-sm font-medium text-slate-700">Nome da Loja</label>
                    <input type="text" wire:model="name"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('name') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">E-mail de contato da Loja</label>
                    <input type="email" wire:model="email"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('email') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Número da Loja</label>
                    <input type="text" wire:model="number"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('number') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div class="sm:col-span-2">
                    <label class="mb-1 block text-sm font-medium text-slate-700">Rito</label>
                    <select wire:model="rite"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                        <option value="">Selecione…</option>
                        @foreach ($rites as $option)
                            <option value="{{ $option }}">{{ $option }}</option>
                        @endforeach
                    </select>
                    @error('rite') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>
            </div>

            <div class="mt-6 flex justify-end">
                <button type="button" wire:click="nextStep" wire:loading.attr="disabled"
                    class="rounded-md bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700 disabled:opacity-50">
                    Próximo
                </button>
            </div>
        @else
            <h2 class="mb-4 text-sm font-semibold text-slate-500 uppercase tracking-wide">Endereço da Loja</h2>
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">CEP</label>
                    <input type="text" wire:model.live.debounce.500ms="cep" x-on:input="$event.target.value = maskCep($event.target.value)"
                        maxlength="9" placeholder="00000-000"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none"
                        wire:loading.class="opacity-50" wire:target="cep">
                    @error('cep') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                    @if ($cepLookupError) <p class="mt-1 text-xs text-red-600">{{ $cepLookupError }}</p> @endif
                </div>

                <div class="sm:col-span-2">
                    <label class="mb-1 block text-sm font-medium text-slate-700">Logradouro</label>
                    <input type="text" wire:model="address_street"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('address_street') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Número</label>
                    <input type="text" wire:model="address_number"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('address_number') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Complemento</label>
                    <input type="text" wire:model="address_complement"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Bairro</label>
                    <input type="text" wire:model="address_neighborhood"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('address_neighborhood') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Cidade</label>
                    <input type="text" wire:model="city"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('city') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Estado</label>
                    <select wire:model="state"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                        <option value="">UF</option>
                        @foreach ($states as $uf)
                            <option value="{{ $uf }}">{{ $uf }}</option>
                        @endforeach
                    </select>
                    @error('state') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>
            </div>

            <h2 class="mt-8 mb-4 text-sm font-semibold text-slate-500 uppercase tracking-wide">Administrador da Loja</h2>
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Nome completo</label>
                    <input type="text" wire:model="admin_name"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_name') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Apelido</label>
                    <input type="text" wire:model="admin_nickname"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">CIM</label>
                    <input type="text" wire:model="admin_cim" maxlength="8"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_cim') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">CPF</label>
                    <input type="text" wire:model.live.debounce.500ms="admin_cpf" x-on:input="$event.target.value = maskCpf($event.target.value)"
                        maxlength="14" placeholder="000.000.000-00"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_cpf') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Grau</label>
                    <select wire:model="admin_degree"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                        <option value="">Selecione…</option>
                        @foreach ($degrees as $option)
                            <option value="{{ $option }}">{{ $option }}</option>
                        @endforeach
                    </select>
                    @error('admin_degree') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">E-mail (login)</label>
                    <input type="email" wire:model="admin_email"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_email') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">WhatsApp</label>
                    <input type="text" wire:model.live.debounce.500ms="admin_whatsapp" x-on:input="$event.target.value = maskWhatsapp($event.target.value)"
                        maxlength="15" placeholder="(11) 94893-2064"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_whatsapp') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div></div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Senha</label>
                    <input type="password" wire:model="admin_password"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                    @error('admin_password') <p class="mt-1 text-xs text-red-600">{{ $message }}</p> @enderror
                </div>

                <div>
                    <label class="mb-1 block text-sm font-medium text-slate-700">Confirmar senha</label>
                    <input type="password" wire:model="admin_password_confirmation"
                        class="w-full rounded-md border border-slate-300 px-3 py-2 text-sm focus:border-slate-500 focus:outline-none">
                </div>
            </div>

            <div class="mt-6 flex justify-between">
                <button type="button" wire:click="previousStep"
                    class="rounded-md border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50">
                    Voltar
                </button>
                <button type="button" wire:click="register" wire:loading.attr="disabled" wire:target="register"
                    class="rounded-md bg-slate-900 px-4 py-2 text-sm font-medium text-white hover:bg-slate-700 disabled:opacity-50">
                    <span wire:loading.remove wire:target="register">Cadastrar Loja</span>
                    <span wire:loading wire:target="register">Cadastrando…</span>
                </button>
            </div>
        @endif
    </div>
</div>
