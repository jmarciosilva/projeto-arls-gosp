<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Potência
    |--------------------------------------------------------------------------
    |
    | Sistema mono-potência: GOSP é constante, não é campo editável em
    | nenhum formulário.
    |
    */
    'power' => 'GOSP',

    /*
    |--------------------------------------------------------------------------
    | Rito
    |--------------------------------------------------------------------------
    */
    'rites' => [
        'Adonhiramita',
        'Brasileiro',
        'Escocês Antigo e Aceito',
        'Escocês Retificado',
        'Maçons Livres Antigos e Aceitos',
        'São João',
        'Schroeder',
        'York',
    ],

    /*
    |--------------------------------------------------------------------------
    | Grau maçônico
    |--------------------------------------------------------------------------
    |
    | Apenas 3 valores. Venerável e demais cargos de loja são tratados como
    | Cargo, não como Grau.
    |
    */
    'degrees' => [
        'Aprendiz',
        'Companheiro',
        'Mestre',
    ],

    /*
    |--------------------------------------------------------------------------
    | Cargo maçônico
    |--------------------------------------------------------------------------
    */
    'positions' => [
        'Venerável Mestre',
        'Primeiro Vigilante',
        'Segundo Vigilante',
        'Orador',
        'Orador Adjunto',
        'Secretário',
        'Secretário Adjunto',
        'Tesoureiro',
        'Tesoureiro Adjunto',
        'Chanceler',
        'Mestre de Cerimônias',
        'Mestre de Cerimônias Adjunto',
        'Guarda do Templo Interno',
        'Guarda do Templo Externo',
        'Arquiteto',
        'Bibliotecário',
        'Hospitaleiro',
        'Porta-Estandarte',
        'Mestre de Harmonia',
        'Mestre de Banquetes',
    ],

    /*
    |--------------------------------------------------------------------------
    | Tipo de Sessão
    |--------------------------------------------------------------------------
    |
    | Também usado como Tipo de Balaústre.
    |
    */
    'session_types' => [
        'Ordinária',
        'Magna',
        'Pública',
        'Econômica/Administrativa',
        'Instrução',
        'Iniciação',
        'Elevação',
        'Exaltação',
        'Especial/Extraordinária',
        'Magna Fúnebre',
    ],

    /*
    |--------------------------------------------------------------------------
    | Situação do Membro
    |--------------------------------------------------------------------------
    */
    'member_statuses' => [
        'candidato',
        'ativo',
        'inativo',
    ],

    /*
    |--------------------------------------------------------------------------
    | Tipo de ingresso
    |--------------------------------------------------------------------------
    */
    'admission_types' => [
        'Iniciação',
        'Regularização',
        'Filiação',
    ],

    /*
    |--------------------------------------------------------------------------
    | Estado civil
    |--------------------------------------------------------------------------
    */
    'marital_statuses' => [
        'Solteiro(a)',
        'Casado(a)',
        'Divorciado(a)',
        'Viúvo(a)',
        'União Estável',
    ],

    /*
    |--------------------------------------------------------------------------
    | Tipo sanguíneo
    |--------------------------------------------------------------------------
    */
    'blood_types' => [
        'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
    ],

    /*
    |--------------------------------------------------------------------------
    | Papéis de usuário (contas de acesso)
    |--------------------------------------------------------------------------
    */
    'user_roles' => [
        'platform_admin',
        'lodge_admin',
        'secretary',
        'member',
    ],

    /*
    |--------------------------------------------------------------------------
    | Estados brasileiros (UF)
    |--------------------------------------------------------------------------
    |
    | Usado tanto para "Natural de" quanto para Estado de endereço.
    |
    */
    'states' => [
        'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO',
        'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI',
        'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
    ],

];
