/// Autogenerated DO NOT EDIT
///
/// (c) Koheron

#ifndef __DRIVERS_MEMORY_HPP__
#define __DRIVERS_MEMORY_HPP__

#include <array>
#include <tuple>
#include <cstdint>

#include <zynq_fclk.hpp>

extern "C" {
  #include <sys/mman.h> // PROT_READ, PROT_WRITE
}

constexpr auto instrument_name = "{{ config['name'] }}";

namespace mem {
{% for addr in config['memory'] -%}
constexpr size_t {{ addr['name'] }} = {{ loop.index0 }};
constexpr uintptr_t {{ addr['name'] }}_addr = {{ addr['offset'] }};
constexpr uint32_t {{ addr['name'] }}_range = {{ addr['range'] | replace_KMG }};
constexpr uint32_t {{ addr['name'] }}_nblocks = {{ addr['n_blocks'] }};
{% endfor %}

constexpr size_t count = {{ config['memory']|length }};

constexpr std::array<std::tuple<uintptr_t, uint32_t, uint32_t, uint32_t>, count> memory_array = {{ '{{' }}
    {% for addr in config['memory'] -%}
        {% if not loop.last -%}
            std::make_tuple({{ addr['name'] }}_addr, {{ addr['name'] }}_range, {{ addr['prot_flag'] }}, {{ addr['name'] }}_nblocks),
        {% else -%}
            std::make_tuple({{ addr['name'] }}_addr, {{ addr['name'] }}_range, {{ addr['prot_flag'] }}, {{ addr['name'] }}_nblocks)
        {% endif -%}
    {% endfor -%}
{{ '}};' }}

} // namespace mem

namespace reg {
// -- Control offsets
{% for offset in config['control_registers'] -%}
constexpr uint32_t {{ offset }} = {{ 4 * loop.index0 }};
static_assert({{ offset }} < mem::control_range, "Invalid control register offset {{ offset }}");
{% endfor %}
// -- PS Control offsets
{% for offset in config['ps_control_registers'] -%}
constexpr uint32_t {{ offset }} = {{ 4 * loop.index0 }};
static_assert({{ offset }} < mem::ps_control_range, "Invalid ps control register offset {{ offset }}");
{% endfor %}
// -- Status offsets
{% for offset in config['status_registers'] -%}
constexpr uint32_t {{ offset }} = {{ 4 * loop.index0 }};
static_assert({{ offset }} < mem::status_range, "Invalid status register offset {{ offset }}");
{% endfor %}
// -- PS Status offsets
{% for offset in config['ps_status_registers'] -%}
constexpr uint32_t {{ offset }} = {{ 4 * loop.index0 }};
static_assert({{ offset }} < mem::status_range, "Invalid ps status register offset {{ offset }}");
{% endfor %}

constexpr uint32_t dna = 0;
} // namespace reg

namespace prm {
{% for key in config['parameters'] -%}
constexpr uint32_t {{ key }} = {{ config['parameters'][key] }};
{% endfor %}

} // namespace prm

namespace zynq_clocks {

inline void set_clocks(ZynqFclk& fclk) {

{% for clk in ['fclk0','fclk1','fclk2','fclk3'] -%}
{% if clk in config['parameters'] -%}
    fclk.set("{{ clk }}", {{ config['parameters'][clk] }});
{% endif -%}
{% endfor %}

}
}

// -- JSONified config
constexpr auto CFG_JSON = "{{ config['json'] }}";

#endif // __DRIVERS_MEMORY_HPP__
